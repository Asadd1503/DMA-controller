
import defs::*;
module axi_master_rd_top (
    input logic clk,
    input logic rst_n,
    // From Arbiter
    input logic [ADDR_W-1:0] src_addr_i,
    input logic              desc_fetch_i,
    input logic              start_read_i,
    input logic [23:0]       transfer_len_i,
   // input logic [2:0]        burst_size_i,
    input logic [ADDR_W-1:0] desc_addr_i,
    //input logic              ch_ready_i,
    input logic              cpu_op_i, 
    // To Arbiter
    output logic             read_done_o,
    output logic             rd_master_idle_o,
    output logic             read_error_o,
    output logic             data_valid_o,
    output logic [128-1:0]   desc_data_o,
    output logic [DATA_W-1:0] cpu_data_o,
    // READ Address Channel
    input logic              ar_ready_i,
    output logic              ar_valid_o,
    output logic [ADDR_W-1:0] ar_addr_o,
    output logic [7:0]       ar_len_o,
    output logic [2:0]       ar_size_o,
    output logic [1:0]       ar_burst_o,
    // READ Data Channel
    input logic              r_valid_i,
    input logic [DATA_W-1:0] r_data_i,
    input logic              r_last_i,
    input logic [1:0]        r_resp_i,
    output logic             r_ready_o,
    // FROM FIFO
    input logic              fifo_full_i,
    //input logic              fifo_empty_i,
    // To FIFO
    output logic              fifo_wr_en_o,
    output logic [DATA_W-1:0] fifo_data_o,
    output logic              rst_rd_fifo_o
    

);


logic load_burst_cntr;
logic load_beat_cntr;
logic burst_done;
logic beat_done;
logic beat_count_en;
logic burst_count_en;
logic r_ready;
logic beat_sel;
logic burst_sel;
logic err;
logic remaining_beats_zero;
logic load_beat_reg;
logic ld_desc_addr;
logic ar_addr_sel;
logic ar_len_sel;
logic sample_en;
logic desc_count_en;
logic ld_desc_data_r;
logic ld_src_addr;
logic ld_trans_len;
logic nxt_addr_sel;
logic desc_count_done;
logic latch_remain_burst_done_flag;
logic remain_burst_done_flag;
logic err_flag;
logic route_zeros;
logic ld_cpu_data;

assign r_ready_o = r_ready;

axi_master_rd_datapath rd_datapath (
    .clk(clk),
    .rst_n(rst_n),
    // From Arbiter
    .src_addr_i(src_addr_i),
    .start_read_i(start_read_i),
    .trans_len_i(transfer_len_i),
    .desc_fetch_i(desc_fetch_i),
    //.burst_size_i(burst_size_i),
    .desc_addr_i(desc_addr_i),
    // To Arbiter
    .desc_data_r(desc_data_o),
    .read_error_o(read_error_o),
    .cpu_data_o(cpu_data_o),
    // To controller
    .burst_done_o(burst_done),
    .beat_done_o(beat_done),
    .remain_burst_done_flag_r(remain_burst_done_flag),
    .desc_count_done_o(desc_count_done),
    .err_o(err),
    .remaining_beats_zero_o(remaining_beats_zero),
    .err_flag_r(err_flag),
    // From controller
    .load_burst_cntr_i(load_burst_cntr),
    .load_beat_cntr_i(load_beat_cntr),
    .beat_sel_i(beat_sel),
    .burst_sel_i(burst_sel),
    .beat_count_en_i(beat_count_en),
    .burst_count_en_i(burst_count_en),
    .r_ready_i(r_ready),
    .load_beats_reg_i(load_beat_reg),
    .ld_desc_addr_i(ld_desc_addr),
    .ar_addr_sel_i(ar_addr_sel),
    .ar_len_sel_i(ar_len_sel),
    .sample_en_i(sample_en),
    .desc_count_en_i(desc_count_en),
    .ld_desc_data_r_i(ld_desc_data_r),
    .ld_src_addr_i(ld_src_addr),
    .ld_trans_len_i(ld_trans_len),
    .nxt_addr_sel_i(nxt_addr_sel),
    .latch_remain_burst_done_flag_i(latch_remain_burst_done_flag),
    .route_zeros_i(route_zeros),
    .ld_cpu_data_i(ld_cpu_data),
    // From memory_controller (AXI_signals)
    .r_valid_i(r_valid_i),
    .r_data_i(r_data_i),
    .r_resp_i(r_resp_i),
    // to memory_controller (AXI_signals)
    .ar_addr_o(ar_addr_o),
    .ar_len_o(ar_len_o),
    .ar_size_o(ar_size_o),
    .ar_burst_o(ar_burst_o),
    // TO FIFO
    .fifo_data_o(fifo_data_o)

);
    
axi_master_rd_ctrl rd_ctrl (
    .clk(clk),
    .rst_n(rst_n),
    // From Datapath
    .burst_done_i(burst_done),
    .beat_done_i(beat_done),
    .desc_count_done_i(desc_count_done),
    .remain_burst_done_flag_i(remain_burst_done_flag),
    .err_i(err),
    .remaining_beats_zero_i(remaining_beats_zero),
    .err_flag_i(err_flag),
    // To Datapath
    .load_burst_cntr_o(load_burst_cntr),
    .load_beat_cntr_o(load_beat_cntr),
    .beat_sel_o(beat_sel),
    .burst_sel_o(burst_sel),
    .beat_count_en_o(beat_count_en),
    .burst_count_en_o(burst_count_en),
    .r_ready_o(r_ready),
    .load_beat_reg_o(load_beat_reg),
    .ld_desc_addr_o(ld_desc_addr),
    .ar_addr_sel_o(ar_addr_sel),
    .ar_len_sel_o(ar_len_sel),
    .sample_en_o(sample_en),
    .desc_count_en_o(desc_count_en),
    .ld_desc_data_r_o(ld_desc_data_r),
    .ld_src_addr_o(ld_src_addr),
    .ld_trans_len_o(ld_trans_len),
    .nxt_addr_sel_o(nxt_addr_sel),
    .route_zeros_o(route_zeros),
    .latch_remain_burst_done_flag_o(latch_remain_burst_done_flag),
    .ld_cpu_data_o(ld_cpu_data),
    // To Arbiter
    .read_done_o(read_done_o),
    .rd_master_idle_o(rd_master_idle_o),
    .data_valid_o(data_valid_o),
    //.read_error_o(read_error_o),
    // From Arbiter
    .start_read_i(start_read_i),
    .desc_fetch_i(desc_fetch_i),
    .cpu_op_i(cpu_op_i),
    // .ch_ready_i(ch_ready_i),
    // To memory_controller (AXI_signals)
    .ar_valid_o(ar_valid_o),
    //.r_ready_o(r_ready_o),
    // From memory_controller (AXI_signals)
    .ar_ready_i(ar_ready_i),
    .r_valid_i(r_valid_i),
    .r_last_i(r_last_i),
    // FROM FIFO
    .fifo_full_i(fifo_full_i),
    // To FIFO
    .fifo_wr_en_o(fifo_wr_en_o),
    .rst_rd_fifo_o(rst_rd_fifo_o)

);

endmodule