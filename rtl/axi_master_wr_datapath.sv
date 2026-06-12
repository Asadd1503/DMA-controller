
import defs::*;
module axi_master_wr_datapath (
    input logic clk,
    input logic rst_n,
    // From Arbiter
    input logic [ADDR_W-1:0] dest_addr_i,
    input logic [23:0]       trans_len_i,
    input logic [DATA_W-1:0]  c_data_i,
    // To Arbiter
    output logic            wr_error_o,
    // From controller
    input logic             ld_dest_addr_i,
    input logic             ld_trans_len_i,
    input logic             nxt_addr_sel_i,
    input logic             ld_burst_cntr_i,
    input logic             burst_count_en_i,
    input logic             burst_sel_i,
    input logic             ld_beat_cntr_i,
    input logic             beat_count_en_i,
    input logic             beat_sel_i,
    input logic             ld_beats_reg_i,
    input logic             ld_cur_addr_i,
    input logic             cur_addr_sel_i,
    input logic             rem_bytes_sel_i,
    input logic             ld_rem_bytes_i,
    input logic             is_first_beat_i,
    input logic             str_resp_i,
    input logic             rst_beat_flag_i,
    input logic             set_beat_flag_i,
    input logic             set_wr_error_i,
    input logic             rst_wr_error_i,
    input logic             latch_remain_burst_done_flag_i,
    input logic             ld_cpu_data_i,
    input logic             sel_cpu_data_i,
     // from memory
    // To controller
    output logic           burst_done_o,
    output logic           beat_done_o,
    output logic           err_o,
    output logic           not_first_beat_flag_o,
    output logic           remaining_beats_zero_o,
    output logic           remain_burst_done_flag_r,
    // To memory
    output logic [ADDR_W-1:0] aw_addr_o,
    output logic [7:0]        aw_len_o,
    output logic [2:0]        aw_size_o,
    output logic [1:0]        aw_burst_o,
    output logic [DATA_W/8-1:0] w_strb_o,
    output logic [DATA_W-1:0] w_data_o,
    // from memory
    input logic [1:0]        b_resp_i,
    // from fifo
    input logic [DATA_W-1:0] fifo_data_i
);

logic [ADDR_W-1:0] dest_addr_r;
logic [ADDR_W-1:0] dest_addr_aligned;
logic [ADDR_W-1:0] dest_addr_nxt_burst;
logic [ADDR_W-1:0] selected_addr;
logic [DATA_W-1:0] w_data_sel;
logic [DATA_W-1:0] c_data_r;
logic [23:0]       trans_len_r;
logic [ADDR_W-1:0] cur_addr_r;
logic [ADDR_W-1:0] cur_addr_selected;
logic [23:0]      rem_bytes_r;
logic [23:0]      rem_bytes_selected;
logic [1:0]       addr_offset;
logic [2:0]       valid_bytes_this_cycle;
logic [3:0]       wstrb;
logic [2:0]       strb_written;
logic [1:0]       b_resp_r;
logic             wr_error_r;

logic [23:0]                         total_beats;
logic [$clog2(MAX_ALLOWED_BURSTS):0] no_bursts;
logic [$clog2(MAX_ALLOWED_BURSTS):0] no_bursts_selected;
logic [$clog2(MAX_BEATS)-1:0]        no_beats;
logic [$clog2(MAX_BEATS)-1:0]        remaining_beats;
logic [$clog2(MAX_BEATS)-1:0]        beat_cntr_data_i;
logic [$clog2(MAX_BEATS)-1:0]        no_beats_r;
//-------------- MUX TO SELECT BETWEEN DESTINATION ADDRESS AND NEXT BURST ADDRESS -------------
always_comb begin : DEST_VS_NXT_BURST_ADDR
    if (nxt_addr_sel_i) selected_addr = dest_addr_nxt_burst;
    else                selected_addr = dest_addr_i;
end
//-----------------------------------------------------------------------------------------------
//------------- DESTINATION ADDRESS REGISTER -------------
always_ff @(posedge clk or negedge rst_n) begin : DEST_ADDR_REG
    if (!rst_n)              dest_addr_r <= '0;
    else if (ld_dest_addr_i) dest_addr_r <= selected_addr;
end
//--------------------------------------------------------
//-------------- ADDRESS ALIGNMENT LOGIC -------------
always_comb begin : ADDR_ALIGNMENT_LOGIC
    dest_addr_aligned = (dest_addr_r & ~('h3)); // <--- CURRENTLY ADDR IS WORD ALIGNED BASED ON MEMORY SIZE IT SHOULD BE CHANGED ACCRODINGLY.
  
end
//------------------------------------------------
//----------------- NEXT BURST ADDR CAL --------------
always_comb begin : nxt_burst_addr_cal
        dest_addr_nxt_burst = dest_addr_aligned + (MAX_BEATS << AWSIZE_4BYTES); // 256 * 4 = 1024 bytes per burst
    end
//------------- TRANSFER LENGTH REGISTER -------------
always_ff @(posedge clk or negedge rst_n) begin : TRANS_LEN_REG
    if (!rst_n) trans_len_r <= '0;
    else if (ld_trans_len_i) trans_len_r <= trans_len_i;
end
//--------------------------------------------------------
//----- Compute Number of Bursts, Beats on the basis of transfer_len and burst_size-----------
always_comb begin : Computation_Unit
    
    total_beats = (trans_len_r + ((AWSIZE_IN_BYTES) - 1)) >> AWSIZE_4BYTES;    // ceiling division
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
//--------------------------------------------------------
// BURST COUNTER INSTANCE
burst_counter #(
    .BURST_CNT_WIDTH($clog2(MAX_ALLOWED_BURSTS)) // Set width based on MAX_ALLOWED_BURSTS
) burst_cnt (
    .clk(clk),
    .rst_n(rst_n),
    // control
    .load(ld_burst_cntr_i),            
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
    .load(ld_beat_cntr_i),            
    .total_beats(beat_cntr_data_i),      
    .count_en(beat_count_en_i), 
    // done signal
    .beat_done(beat_done_o)
);

//----------------- MUX to SELECT NO BURSTS FOR COUNTER -----------------
always_comb begin : NO_BURST_SEL_MUX
    if (!burst_sel_i) no_bursts_selected = no_bursts;
    else              no_bursts_selected = 1; // If burst_sel_i is high, it means we are in the last burst with remaining beats, so we set no_bursts to 1. 
end
//------------------------------------------------------

//------- MUX to select between no_beats and remaining_beats for ar_len_o and BEAT COUNTER---
always_comb begin 
    if (!beat_sel_i) begin
        beat_cntr_data_i = (no_beats - 1);
    end
    else begin
        beat_cntr_data_i = (remaining_beats - 1);
    end
end
//------------------------------------------------------------
//------------------ BEATS REG -----------------------
always_ff @(posedge clk or negedge rst_n) begin : BEATS_REG
    if (!rst_n) no_beats_r <= '0;
    else if (ld_beats_reg_i) no_beats_r <= beat_cntr_data_i;
    
end
//------------------------------------------------------------
//----------------- CURRENT ADDRESS CALCULATOR -------------- 
always_ff @(posedge clk or negedge rst_n) begin : CUR_ADDR_REG
    if (!rst_n)             cur_addr_r <= '0;
    else if (ld_cur_addr_i) cur_addr_r <= cur_addr_selected;

end
//----------------- MUX TO SELECT CURRENT ADDRESS VS UPDATED ADDR -----------------
always_comb begin : CUR_ADDR_VS_UPDATED_ADDR_MUX
    if (!cur_addr_sel_i) cur_addr_selected = dest_addr_r;
    else                 cur_addr_selected = ((cur_addr_r & ~('h3)) + AWSIZE_IN_BYTES);
    
end
//------------------------------------------------------------
//----------------- REMAINING BYTES CALCULATOR -----------------
always_ff @(posedge clk or negedge rst_n) begin : REM_BYTES_REG
    if (!rst_n)              rem_bytes_r <= '0;
    else if (ld_rem_bytes_i) rem_bytes_r <= rem_bytes_selected;
end
//----------------- MUX TO SELECT BETWEEN TRANSFER_LEN AND REMAINING BYTES -----------------
always_comb begin : REMAINING_BYTES_VS_TRANSFER_LEN_MUX
    if (!rem_bytes_sel_i) rem_bytes_selected = trans_len_r;
    else                  rem_bytes_selected = rem_bytes_r - strb_written;
    
end
//------------------------------------------------------------
//----------------- STRB CALCULATOR -----------------
assign addr_offset = cur_addr_r[1:0];

always_comb begin : Strobe_Generator

    if (is_first_beat_i) begin
        if (rem_bytes_r < (4 - addr_offset)) begin
            valid_bytes_this_cycle = rem_bytes_r[2:0];
        end else begin
            valid_bytes_this_cycle = 3'(4 - addr_offset);
        end
    end 
    else begin

        if (rem_bytes_r < 4) begin
            valid_bytes_this_cycle = rem_bytes_r[2:0];
        end else begin
            valid_bytes_this_cycle = 3'd4;
        end
    end
    case (valid_bytes_this_cycle)
        3'd1: wstrb = 4'b0001 << addr_offset;
        3'd2: wstrb = 4'b0011 << addr_offset;
        3'd3: wstrb = 4'b0111 << addr_offset;
        3'd4: wstrb = 4'b1111 << addr_offset; 
        default: wstrb = 4'b0000;
    endcase
end
//------------------------------------------------------------
//----------------- STRB WRITTEN CALCULATOR -----------------
always_comb begin : STRB_WRITTEN_CALCULATOR
    case (wstrb)
        4'b0001: strb_written = 3'd1;
        4'b0010: strb_written = 3'd1;
        4'b0100: strb_written = 3'd1;
        4'b1000: strb_written = 3'd1;
        4'b0011: strb_written = 3'd2;
        4'b0110: strb_written = 3'd2;
        4'b1100: strb_written = 3'd2;
        4'b0111: strb_written = 3'd3;
        4'b1110: strb_written = 3'd3;
        4'b1111: strb_written = 3'd4;
        default: strb_written = 3'd0;
    endcase
end
//------------------------------------------------------------
//----------------- B_RESP STORAGE AND CHECK -------------------
always_ff @(posedge clk or negedge rst_n) begin : RESP_REG
    if (!rst_n)            b_resp_r <= 0;
    else if (str_resp_i)   b_resp_r <= b_resp_i; 
end

always_comb begin : RESP_CHECK
    err_o = 0;
    if (b_resp_r[1]) begin
        err_o = 1;              // SLVERR or DECERR        
    end
end
//------------------------------------------------------------
always_ff @(posedge clk) begin : not_first_beat_flag_reg
    if (!rst_beat_flag_i) begin
        not_first_beat_flag_o <= 0;
    end else if (set_beat_flag_i)begin
        not_first_beat_flag_o <= 1;
    end
end
//-------------------------------------------------------------
// logic to determine if they are remaining beats or not.
always_comb begin
    if (!remaining_beats) begin
        remaining_beats_zero_o = 1; 
    end
    else begin
        remaining_beats_zero_o = 0;
     end
end
//---------------- REG TO INDICATE WHETHER THE REMAINING BEATS BURST IS DONE OR NOT ---------------
always_ff @(posedge clk or negedge rst_n) begin : remain_burst_done_flag_reg
    if (!rst_n)                                        remain_burst_done_flag_r <= 0;
    else if (latch_remain_burst_done_flag_i)           remain_burst_done_flag_r <= 1;           // Latch the flag when processing the remaining beats burst
    else if (burst_done_o && remain_burst_done_flag_r) remain_burst_done_flag_r <= 0;           // Clear the flag after processing the remaining beats burst
end
//-------------------------------------------------------------------------------------------------
//------------------ WR ERROR FLAG REG --------------------
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)               wr_error_r <= 0;
    else if (!rst_wr_error_i) wr_error_r <= 0; // Clear the error flag at the beginning of a new transfer
    else if (set_wr_error_i)  wr_error_r <= 1; 
    
end
//------------------------------------------------------------
//------------------ CPU DATA REGISTER --------------------
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)                  c_data_r <= '0;
    else if (ld_cpu_data_i)      c_data_r <= c_data_i;
end
//----------------- OUTPUT SELECT BETWEEN FIFO DATA AND CPU DATA -------------
always_comb begin : cpu_vs_fifo_data_Sel_mux
    if (sel_cpu_data_i) w_data_sel = c_data_r;
    else                w_data_sel = fifo_data_i;
    
end

assign aw_addr_o =  dest_addr_r;
assign aw_len_o  =  no_beats_r;
assign aw_size_o =  AWSIZE_4BYTES;
assign aw_burst_o = BURST_INCR;
assign w_strb_o   = wstrb;
assign w_data_o   = w_data_sel;
assign wr_error_o = wr_error_r;

endmodule