
import defs::*;

module axi_master_rd_datapath (
    input logic clk,
    input logic rst_n,
    // From Arbiter
    input logic [ADDR_W-1:0] src_addr_i,
    input logic start_read_i,
    input logic desc_fetch_i,
    input logic [23:0] trans_len_i,
    input logic [ADDR_W-1:0] desc_addr_i,
    // To Arbiter
    output logic [128-1:0] desc_data_r,
    output logic read_error_o,
    output logic [DATA_W-1:0] cpu_data_o,
    // To memory_controller (AXI_signals)
    // READ Address Channel
    //output logic              ar_valid_o,
    output logic [ADDR_W-1:0] ar_addr_o,
    output logic [7:0]       ar_len_o,
    output logic [2:0]       ar_size_o,
    output logic [1:0]       ar_burst_o,
    // READ Data Channel
    //output logic              r_ready_o,
    // From memory_controller (AXI_signals)
    // READ Data Channel
    input logic              r_valid_i,
    input logic [DATA_W-1:0] r_data_i,
    //input logic              r_last_i,
    input logic [1:0]       r_resp_i,
    // FROM controller
    input logic load_burst_cntr_i,
    input logic load_beat_cntr_i,
    input logic beat_count_en_i,
    input logic burst_count_en_i,
    input logic r_ready_i,
    input logic beat_sel_i, // 0 for no_beats, 1 for remaining_beats
    input logic burst_sel_i, 
    input logic load_beats_reg_i,
    input logic ld_desc_addr_i,
    input logic ar_addr_sel_i,
    input logic ar_len_sel_i,
    input logic sample_en_i,
    input logic desc_count_en_i,
    input logic ld_desc_data_r_i,
    input logic ld_src_addr_i,
    input logic ld_trans_len_i,
    input logic nxt_addr_sel_i,
    input logic route_zeros_i,
    input logic latch_remain_burst_done_flag_i,
    input logic ld_cpu_data_i,
    // To controller
    output logic burst_done_o,
    output logic beat_done_o,
    output logic err_o,
    output logic remaining_beats_zero_o, // This signal indicates whether there are remaining beats or not.
    output logic desc_count_done_o,
    output logic remain_burst_done_flag_r,
    output logic err_flag_r,
    // To FIFO
    output logic [DATA_W-1:0] fifo_data_o
);

logic [ADDR_W-1:0] src_addr_r;
logic [ADDR_W-1:0] desc_addr_r;
logic [ADDR_W-1:0] src_addr_aligned;
logic [ADDR_W-1:0] src_addr_mux_o;
logic [ADDR_W-1:0] src_addr_nxt_burst;
logic [DATA_W-1:0] r_data_mux_o;
logic [DATA_W-1:0] cpu_data_read_r;

logic [23:0] trans_len_r;
logic [127:0] sample_reg_data_o;


logic [23:0]                         total_beats;
logic [$clog2(MAX_ALLOWED_BURSTS):0] no_bursts;
logic [$clog2(MAX_ALLOWED_BURSTS):0] no_bursts_selected;
logic [$clog2(MAX_BEATS):0]        no_beats;
logic [$clog2(MAX_BEATS):0]        remaining_beats;
logic [$clog2(MAX_BEATS):0]        beat_cntr_data_i;
logic [$clog2(MAX_BEATS):0]        no_beats_r;
//logic select_addr_mux; 
assign read_error_o = err_flag_r; 
//assign ar_addr_o = addr_mux_o;
assign ar_burst_o = ARBURST_INCR; 
assign ar_size_o =  ARSIZE_4BYTES;
// DATA TO FIFO
assign fifo_data_o = r_data_mux_o;
assign cpu_data_o = cpu_data_read_r;

//---------------- SRC_ADDR_SEL_MUX ------------------
always_comb begin : src_addr_sel_mux
    if (nxt_addr_sel_i) src_addr_mux_o = src_addr_nxt_burst;
    else                src_addr_mux_o = src_addr_i;
end
//----------------------------------------------------
//---------------- SRC ADDR REG ----------------------
always_ff @(posedge clk or negedge rst_n) begin : SRC_ADDR_REG
    if (!rst_n) src_addr_r <= '0;
    else if (ld_src_addr_i) src_addr_r <= src_addr_mux_o;
end
//---------------------------------------------------
//----------------- NEXT BURST ADDR CAL --------------
always_comb begin : nxt_burst_addr_cal
        src_addr_nxt_burst = src_addr_aligned + (MAX_BEATS << ARSIZE_4BYTES); // 256 * 4 = 1024 bytes per burst
end
//-----------------------------------------------------
//----------------- TRANSFER LEN REG ----------------------
always_ff @(posedge clk or negedge rst_n) begin : TRANSFER_LEN_REG
    if (!rst_n) trans_len_r <= '0;
    else if (ld_trans_len_i) trans_len_r <= trans_len_i;
end
//-------------------------------------------------------  
//---------------- ADRESS ALIGNMENT BLOCK ------------
always_comb begin : ADDR_ALGIN_BLOCK
    src_addr_aligned = (src_addr_r & ~('h3)); // <--- CURRENTLY ADDR IS WORD ALIGNED BASED ON MEMORY SIZE IT SHOULD BE CHANGED ACCRODINGLY.
end
//------------------------------------------------------
// --------------- DESC ADDR REG ----------------------
always_ff @(posedge clk or negedge rst_n) begin : DESC_ADDR_REG
    if (!rst_n) desc_addr_r <= '0;
    else if (ld_desc_addr_i) desc_addr_r <= desc_addr_i;
end
//-------------------------------------------------------
//----- Compute Number of Bursts, Beats on the basis of transfer_len and burst_size-----------
always_comb begin : Computation_Unit
    
    total_beats = (trans_len_r + ((ARSIZE_IN_BYTES) - 1)) >> ARSIZE_4BYTES;    // ceiling division
    if (total_beats <= MAX_BEATS) begin
        no_bursts = 1;
        no_beats = total_beats;
        remaining_beats = 8'h00;                                               // For AXI4, this will give us the number of beats in the last burst if it's not a full burst
    end
    else begin
        no_bursts = total_beats >> LOG2_MAX_BEATS;                             // Number of full bursts
        no_beats = MAX_BEATS;                                                  // Full burst size
        remaining_beats = total_beats & MASK_FOR_REMAINDER;                    // Remaining beats for the last burst
        if (no_bursts > MAX_ALLOWED_BURSTS) begin
            no_bursts = MAX_ALLOWED_BURSTS;                                    // Cap the number of bursts to the maximum allowed
        end
    end
    
end
// BURST COUNTER INSTANCE
burst_counter #(
    .BURST_CNT_WIDTH($clog2(MAX_ALLOWED_BURSTS)) // Set width based on MAX_ALLOWED_BURSTS
) burst_cnt (
    .clk(clk),
    .rst_n(rst_n),
    // control
    .load(load_burst_cntr_i),            
    .total_bursts(no_bursts_selected),      
    .count_en(burst_count_en_i), 
    //done signal
    .burst_done(burst_done_o)   
);
// BEAT COUNTER INSTANCE
beat_counter #(
    .BEAT_CNT_WIDTH(LOG2_MAX_BEATS) // Set width based on MAX_BEATS
) beat_cnt (
    .clk(clk),
    .rst_n(rst_n),
    // control
    .load(load_beat_cntr_i),            
    .total_beats(beat_cntr_data_i),      
    .count_en(beat_count_en_i), 
    // done signal
    .beat_done(beat_done_o)
);
// rresp check logic
// We can check r_resp_i when r_valid_i and r_ready_o are high
always_comb begin
    if (r_valid_i && r_ready_i) begin
        if (r_resp_i[1] == 1'b1) begin
            err_o = 1;
        end
        else begin
            err_o = 0;
        end
    end
    else begin
        err_o = 0;
    end
    
end
//------------------- AR ADDR SELECT MUX (DESC VS DATA)-------------------
always_comb begin : AR_ADDR_SEL_MUX
    if (ar_addr_sel_i) ar_addr_o = desc_addr_r;
    else               ar_addr_o = src_addr_aligned;
end
//------------------------------------------------------------------------
//------------------ BEATS REG -----------------------
always_ff @(posedge clk or negedge rst_n) begin : BEATS_REG
    if (!rst_n) no_beats_r <= '0;
    else if (load_beats_reg_i) no_beats_r <= (beat_cntr_data_i - 1);
    
end
//------------------ AR LEN SEL MUX (DESC_LEN VS BURST LEN)---------------
always_comb begin : AR_LEN_SEL_MUX
    if (ar_len_sel_i) ar_len_o = (DESC_NO_TRANSFERS - 1);
    else              ar_len_o = (no_beats_r);
end
//-------------------------------------------------------------------

//------- MUX to select between no_beats and remaining_beats for ar_len_o and BEAT COUNTER---
always_comb begin 
    if (!beat_sel_i) begin
        beat_cntr_data_i = (no_beats);
    end
    else begin
        beat_cntr_data_i = (remaining_beats);
    end
end
//------------------------------------------------------------

// logic to determine if they are remaining beats or not.
always_comb begin
    if (!remaining_beats) begin
        remaining_beats_zero_o = 1; 
    end
    else begin
        remaining_beats_zero_o = 0;
     end
end
//---------------- NO BURST SEL MUX --------------------
always_comb begin : NO_BURST_SEL_MUX
    if (!burst_sel_i) no_bursts_selected = no_bursts;
    else              no_bursts_selected = 1; // If burst_sel_i is high, it means we are in the last burst with remaining beats, so we set no_bursts to 1. 
end
//------------------------------------------------------
//-----------------SHIFT REG TO HOLD DESC DATA----------------
sample_reg sample_reg_inst (
    .clk(clk),
    .rst_n(rst_n),
    .sample_en_i(sample_en_i),
    .data_in_i(r_data_i),
    .data_out_o(sample_reg_data_o)
);
//------------------------------------------------------------
//----------------- DESC DATA REG ---------------------------
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) desc_data_r <= '0;
    else if (ld_desc_data_r_i) desc_data_r <= sample_reg_data_o;
//-----------------------------------------------------------
  
end
//-------------------------------------------------------------
//----------------- COUNTER FOR DESC TRANSFERS ----------------
desc_counter desc_counter_inst (
    .clk(clk),
    .rst_n(rst_n),
    .desc_count_en_i(desc_count_en_i),
    .ld_desc_cntr_i(ld_desc_addr_i), 
    .desc_count_done_o(desc_count_done_o)
);
//------------------------------------------------------------
//---------------- MUX TO SELECT RDATA VS ZEROS IN CASE OF ERROR ---------------
always_comb begin : mux_to_Sel_rdata_or_zeros
    if (route_zeros_i) r_data_mux_o = '0; // Route zeros to FIFO in case of error
    else               r_data_mux_o = r_data_i; // Route actual data to FIFO when there's no error
end
//-----------------------------------------------------------------------------
//---------------- REG TO STORE ERROR FLAG ----------------
always_ff @(posedge clk or negedge rst_n) begin : err_flag_reg
    if (!rst_n) err_flag_r <= 0;
    else if (route_zeros_i) err_flag_r <= 1; // Set error flag when route_zeros_i is asserted
    else if (start_read_i || desc_fetch_i)  err_flag_r <= 0; 
end
//-------------------------------------------------------------
//---------------- REG TO INDICATE WHETHER THE REMAINING BEATS BURST IS DONE OR NOT ---------------
always_ff @(posedge clk or negedge rst_n) begin : remain_burst_done_flag_reg
    if (!rst_n) remain_burst_done_flag_r <= 0;
    else if (latch_remain_burst_done_flag_i) remain_burst_done_flag_r <= 1; // Latch the flag when processing the remaining beats burst
    else if (burst_done_o && remain_burst_done_flag_r) remain_burst_done_flag_r <= 0; // Clear the flag after processing the remaining beats burst
end
//------------------------------------------------------------
//---------------- CPU DATA READ REG ----------------------
always_ff @(posedge clk or negedge rst_n) begin : CPU_DATA_READ_REG
    if (!rst_n)             cpu_data_read_r <= '0;
    else if (ld_cpu_data_i) cpu_data_read_r <= r_data_mux_o;
end
//----------------------------------------------------------
    
    



endmodule