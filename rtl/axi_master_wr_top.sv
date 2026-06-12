
import defs::*;
module axi_master_wr_top (
    input logic clk,
    input logic rst_n,
    // to arbiter
    output logic             wr_master_idle_o,
    output logic             wr_done_o,
    output logic             wr_error_o,
    // From Arbiter
    input logic [ADDR_W-1:0] dest_addr_i,
    input logic              start_write_i,
    input logic [23:0]       transfer_len_i,
    input logic [DATA_W-1:0]  c_data_i,
    input logic              cpu_op_i,
    // AW ADDRESS CHANNEL
    output logic              aw_valid_o,
    output logic [ADDR_W-1:0] aw_addr_o,
    output logic [7:0]        aw_len_o,
    output logic [2:0]        aw_size_o,
    output logic [1:0]        aw_burst_o,
    input logic               aw_ready_i,
    // WRITE DATA CHANNEL
    output logic              w_valid_o,
    output logic [DATA_W-1:0] w_data_o,
    input logic               w_ready_i,
    // WRITE RESPONSE CHANNEL
    output logic              b_ready_o,
    input logic               b_valid_i,
    input logic [1:0]         b_resp_i,
    // FROM FIFO
    input logic               fifo_empty_i,
    input logic [DATA_W-1:0]  fifo_data_i,
    // TO FIFO
    output logic              fifo_rd_en_o,
    output logic              rst_wr_fifo_o


);
logic            ld_dest_addr;
logic            ld_trans_len;
logic            nxt_addr_sel;
logic            ld_burst_cntr;
logic            burst_count_en;
logic            burst_sel;
logic            ld_beat_cntr;
logic            beat_count_en;
logic            beat_sel;
logic            ld_beats_reg;
logic            ld_cur_addr;
logic            cur_addr_sel;
logic            rem_bytes_sel;
logic            ld_rem_bytes;
logic            is_first_beat;
logic            beat_done;
logic            burst_done;
logic            str_resp;
logic            err;
logic            rst_beat_flag;
logic            set_beat_flag;
logic            remaining_beats_zero;
logic            not_first_beat_flag;
logic            set_wr_error;
logic            remain_burst_done_flag;
logic            latch_remain_burst_done_flag;
logic            rst_wr_error;
logic            ld_cpu_data;
logic            sel_cpu_data;



axi_master_wr_datapath wr_datapath (
    .clk(clk),
    .rst_n(rst_n),
    // To Arbiter
    .wr_error_o(wr_error_o),
    // From Arbiter
    .dest_addr_i(dest_addr_i),
    .trans_len_i(transfer_len_i),
    .c_data_i(c_data_i),
    // to controller
    .beat_done_o(beat_done),
    .burst_done_o(burst_done),
    .err_o(err),
    .not_first_beat_flag_o(not_first_beat_flag),
    .remaining_beats_zero_o(remaining_beats_zero),
    .remain_burst_done_flag_r(remain_burst_done_flag),
    //from controller  
    .ld_dest_addr_i(ld_dest_addr),
    .ld_trans_len_i(ld_trans_len),
    .nxt_addr_sel_i(nxt_addr_sel), 
    .ld_burst_cntr_i(ld_burst_cntr),
    .burst_count_en_i(burst_count_en),
    .set_wr_error_i(set_wr_error),
    .rst_wr_error_i(rst_wr_error),
    .burst_sel_i(burst_sel),
    .ld_beat_cntr_i(ld_beat_cntr),
    .beat_count_en_i(beat_count_en),
    .beat_sel_i(beat_sel),
    .ld_beats_reg_i(ld_beats_reg), 
    .ld_cur_addr_i(ld_cur_addr),
    .cur_addr_sel_i(cur_addr_sel),
    .rem_bytes_sel_i(rem_bytes_sel),
    .ld_rem_bytes_i(ld_rem_bytes),
    .is_first_beat_i(is_first_beat),
    .str_resp_i(str_resp),
    .rst_beat_flag_i(rst_beat_flag),
    .set_beat_flag_i(set_beat_flag),
    .latch_remain_burst_done_flag_i(latch_remain_burst_done_flag),
    .ld_cpu_data_i(ld_cpu_data),
    .sel_cpu_data_i(sel_cpu_data),
     // to memory
    // to memory
    // WRITE ADDRESS CHANNEL
    .aw_addr_o(aw_addr_o),
    .aw_len_o(aw_len_o),
    .aw_size_o(aw_size_o),
    .aw_burst_o(aw_burst_o),
        // WRITE DATA CHANNEL
    .w_data_o(w_data_o),
    // from memory
    .b_resp_i(b_resp_i),
    // from fifo
    .fifo_data_i(fifo_data_i)

);

axi_master_wr_ctrl wr_ctrl (
    .clk(clk),
    .rst_n(rst_n),
    // To Arbiter
    .wr_master_idle_o(wr_master_idle_o),
    .wr_done_o(wr_done_o),
    //.wr_error_o(wr_error_o),
    // From Arbiter
    .start_write_i(start_write_i),
    .cpu_op_i(cpu_op_i),
    // from datapath
    .beat_done_i(beat_done),
    .burst_done_i(burst_done),
    .remaining_beats_zero_i(remaining_beats_zero),
    .not_first_beat_flag_i(not_first_beat_flag),
    .remain_burst_done_flag_i(remain_burst_done_flag),
    .err_i(err),
    //to datapath
    .set_wr_error_o(set_wr_error),
    .rst_wr_error_o(rst_wr_error),
    .ld_dest_addr_o(ld_dest_addr),
    .ld_trans_len_o(ld_trans_len),
    .nxt_addr_sel_o(nxt_addr_sel),
    .ld_burst_cntr_o(ld_burst_cntr),
    .burst_count_en_o(burst_count_en),
    .burst_sel_o(burst_sel),
    .ld_beat_cntr_o(ld_beat_cntr),
    .beat_count_en_o(beat_count_en),
    .beat_sel_o(beat_sel),
    .ld_beats_reg_o(ld_beats_reg),
    .ld_cur_addr_o(ld_cur_addr),
    .cur_addr_sel_o(cur_addr_sel),
    .rem_bytes_sel_o(rem_bytes_sel),
    .ld_rem_bytes_o(ld_rem_bytes),
    .str_resp_o(str_resp),
    .is_first_beat_o(is_first_beat),
    .rst_beat_flag_o(rst_beat_flag),
    .set_beat_flag_o(set_beat_flag),
    .latch_remain_burst_done_flag_o(latch_remain_burst_done_flag),
    .ld_cpu_data_o(ld_cpu_data),
    .sel_cpu_data_o(sel_cpu_data),
    // to memory interface
    .aw_valid_o(aw_valid_o),
    .aw_ready_i(aw_ready_i),
    // write data channel
    .w_valid_o(w_valid_o),
    .w_ready_i(w_ready_i),
    // write response channel
    .b_ready_o(b_ready_o),
    .b_valid_i(b_valid_i),
    // from fifo
    .fifo_empty_i(fifo_empty_i),
    // to fifo
    .fifo_rd_en_o(fifo_rd_en_o),
    .rst_wr_fifo_o(rst_wr_fifo_o)
);


    
endmodule