import defs::*;

module axi_master_top (
    input logic clk,
    input logic rst_n,
    // From Arbiter
    input logic [ADDR_W-1:0] src_addr_i,
    input logic              start_read_i,
    input logic [23:0]       transfer_len_i,
    //input logic [2:0]      burst_size_i,
    input logic              desc_fetch_i,
    input logic [ADDR_W-1:0] desc_addr_i,
    //input logic              ch_ready_i, // <-- remove this from axi rd master
    input logic [ADDR_W-1:0] dest_addr_i,
    input logic              start_write_i,

    // To Arbiter
    output logic             read_done_o,
    output logic             rd_master_idle_o,
    output logic             read_error_o,
    output logic             data_valid_o,
    output logic [128-1:0]   desc_data_o,
    output logic             wr_master_idle_o,
    output logic             wr_done_o,
    output logic             wr_error_o,
    // READ Address Channel
    input logic              ar_ready_i,
    output logic             ar_valid_o,
    output logic [ADDR_W-1:0] ar_addr_o,
    output logic [7:0]       ar_len_o,
    output logic [2:0]       ar_size_o,
    output logic [1:0]       ar_burst_o,
    // WRITE Address Channel
    input  logic              aw_ready_i,
    output logic              aw_valid_o,
    output logic [ADDR_W-1:0] aw_addr_o,
    output logic [7:0]        aw_len_o,
    output logic [2:0]        aw_size_o,
    output logic [1:0]        aw_burst_o,
    // READ Data Channel
    input logic              r_valid_i,
    input logic [DATA_W-1:0] r_data_i,
    input logic              r_last_i,
    input logic [1:0]        r_resp_i,
    output logic             r_ready_o,
    // WRITE DATA CHANNEL
    output logic              w_valid_o,
    output logic [DATA_W-1:0] w_data_o,
    input logic               w_ready_i,
    // WRITE RESPONSE CHANNEL
    input logic               b_valid_i,
    input logic [1:0]         b_resp_i,
    output logic              b_ready_o


);
logic fifo_full, fifo_empty, fifo_wr_en, fifo_rd_en;
logic [DATA_W-1:0] fifo_wr_data;
logic [DATA_W-1:0] fifo_rd_data;


axi_master_rd_top axi_master_rd_top_inst (
    .clk(clk),
    .rst_n(rst_n),
    // From Arbiter
    .src_addr_i(src_addr_i),
    .start_read_i(start_read_i),
    .transfer_len_i(transfer_len_i),
    // .burst_size_i(burst_size_i),
    .desc_fetch_i(desc_fetch_i),
    .desc_addr_i(desc_addr_i),
    // .ch_ready_i(ch_ready_i),
    // To Arbiter
    .read_done_o(read_done_o),
    .rd_master_idle_o(rd_master_idle_o),
    .read_error_o(read_error_o),
    .data_valid_o(data_valid_o),
    .desc_data_o(desc_data_o),
    // READ Address Channel
    .ar_ready_i(ar_ready_i),
    .ar_valid_o(ar_valid_o),
    .ar_addr_o(ar_addr_o),
    .ar_len_o(ar_len_o),
    .ar_size_o(ar_size_o),
    .ar_burst_o(ar_burst_o),
    // READ Data Channel
    .r_valid_i(r_valid_i),
    .r_data_i(r_data_i),
    .r_last_i(r_last_i),
    .r_resp_i(r_resp_i),
    .r_ready_o(r_ready_o),
    // FROM FIFO
    .fifo_full_i(fifo_full),
    //.fifo_empty_i(fifo_empty),
    // To FIFO
    .fifo_wr_en_o(fifo_wr_en),
    .fifo_data_o(fifo_wr_data)

);

axi_master_wr_top axi_master_wr_top_inst (
    .clk(clk),
    .rst_n(rst_n),
    // To Arbiter
    .wr_master_idle_o(wr_master_idle_o),
    .wr_done_o(wr_done_o),
    .wr_error_o(wr_error_o),
    // From Arbiter
    .dest_addr_i(dest_addr_i),
    .start_write_i(start_write_i),
    .transfer_len_i(transfer_len_i),
    // WRITE ADDRESS CHANNEL
    .aw_ready_i(aw_ready_i),
    .aw_valid_o(aw_valid_o),
    .aw_addr_o(aw_addr_o),
    .aw_len_o(aw_len_o),
    .aw_size_o(aw_size_o),
    .aw_burst_o(aw_burst_o),
    // WRITE DATA CHANNEL
    .w_valid_o(w_valid_o),
    .w_ready_i(w_ready_i),
    .w_data_o(w_data_o),
    // WRITE RESPONSE CHANNEL
    .b_ready_o(b_ready_o),
    .b_valid_i(b_valid_i),
    .b_resp_i(b_resp_i),
    // FROM FIFO
    .fifo_empty_i(fifo_empty),
    .fifo_data_i(fifo_rd_data),
    // TO FIFO
    .fifo_rd_en_o(fifo_rd_en)

);
sync_fifo #(
    .DATA_WIDTH(32),
    .FIFO_DEPTH(16)
) fifo_inst (
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(fifo_wr_en), 
    .wr_data(fifo_wr_data), 
    .rd_en(fifo_rd_en),
    .rd_data(fifo_rd_data),
    .full(fifo_full),
    .empty(fifo_empty)
);
endmodule