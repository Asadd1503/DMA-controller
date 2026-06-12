

module axi_master_wr_ctrl (
    input logic clk,
    input logic rst_n,
    // From Arbiter
    input logic              start_write_i,
    input logic              cpu_op_i,
    // To Arbiter
    output logic             wr_master_idle_o,
    output logic             wr_done_o,
    //output logic             wr_error_o,
    // from datapath
    input logic              beat_done_i,
    input logic              burst_done_i,
    input logic              err_i,
    input logic              not_first_beat_flag_i,
    input logic              remaining_beats_zero_i,
    input logic              remain_burst_done_flag_i,
     // To datapath
    output logic             ld_dest_addr_o,
    output logic             ld_trans_len_o,
    output logic             nxt_addr_sel_o,
    output logic             ld_burst_cntr_o,
    output logic             burst_count_en_o,
    output logic             burst_sel_o,
    output logic             ld_beat_cntr_o,
    output logic             beat_count_en_o,
    output logic             beat_sel_o,
    output logic             ld_beats_reg_o,
    output logic             ld_cur_addr_o,
    output logic             cur_addr_sel_o,
    output logic             rem_bytes_sel_o,
    output logic             ld_rem_bytes_o,
    output logic             is_first_beat_o,
    output logic             str_resp_o,
    output logic             rst_beat_flag_o,
    output logic             set_beat_flag_o,
    output logic             latch_remain_burst_done_flag_o,
    output logic             set_wr_error_o,
    output logic             rst_wr_error_o,
    output logic             ld_cpu_data_o,
    output logic             sel_cpu_data_o,
     // To Arbiter
    // write address channel
    output logic             aw_valid_o,
    input logic              aw_ready_i,
    // write data channel
    output logic             w_valid_o,
    input logic              w_ready_i,
    // wr response channel
    input logic              b_valid_i,
    output logic             b_ready_o,
    // FROM FIFO
    input logic              fifo_empty_i,
    // TO FIFO
    output logic             fifo_rd_en_o,
    output logic             rst_wr_fifo_o
);

typedef enum  logic [3:0] {
    IDLE,
    LOAD_DESC_DATA,
    LOAD,
    SEND_AW,
    SEND_DATA,
    CONTINUE_SEND,
    WAIT_FOR_READY,
    WAIT_EMPTY,
    RCV_RESP,
    RESP_CHECK,
    BURST_COUNT,
    CHECK_REMAINING,
    WRITE_DONE,
    WR_ERROR
    
} state_t;

state_t c_state, n_state;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        c_state <= IDLE;
    end
    else begin
        c_state <= n_state;
    end
end

always_comb begin : next_state_logic_determination
    case(c_state)
        IDLE: begin
            if (start_write_i) begin
                n_state = LOAD_DESC_DATA;
            end
            else begin
                n_state = IDLE;
            end
        end
        LOAD_DESC_DATA: begin
            n_state = LOAD;
        end
        LOAD: begin
            n_state = SEND_AW;
        end
        SEND_AW: begin
            if (aw_ready_i) begin
                n_state = SEND_DATA;
            end
            else begin
                n_state = SEND_AW;
            end
        end
        SEND_DATA: begin
            if (!fifo_empty_i && w_ready_i) begin
                n_state = CONTINUE_SEND;
            end
            else begin
                n_state = SEND_DATA;
            end
        end
        CONTINUE_SEND: begin
            if (!w_ready_i) begin
                n_state = WAIT_FOR_READY; 
            end
            else if (fifo_empty_i) begin
                n_state = WAIT_EMPTY;
            end
            else if (beat_done_i) begin
                n_state = RCV_RESP;
            end
            else begin
                n_state = CONTINUE_SEND;
            end
        end
        WAIT_FOR_READY: begin
            if (w_ready_i) begin
                n_state = CONTINUE_SEND;
            end
            else begin
                n_state = WAIT_FOR_READY;
            end
        end
        WAIT_EMPTY: begin
            if (!fifo_empty_i) begin
                n_state = CONTINUE_SEND;
            end
            else begin
                n_state = WAIT_EMPTY;
            end
        end
        RCV_RESP: begin
            if (b_valid_i) begin
                n_state = RESP_CHECK;
            end
            else begin
                n_state = RCV_RESP;
            end
        end
        RESP_CHECK: begin
            if (err_i) begin
                n_state = WR_ERROR;
            end
            else begin
                n_state = BURST_COUNT;
            end
        end
        BURST_COUNT: begin
            if (burst_done_i && remain_burst_done_flag_i) begin
                n_state = WRITE_DONE;
            end
            else if (burst_done_i) begin
                n_state = CHECK_REMAINING;
            end
            else begin
                n_state = SEND_AW;
            end
        end
        CHECK_REMAINING: begin
            if (remaining_beats_zero_i) begin
                n_state = WRITE_DONE;
            end
            else begin
                n_state = SEND_AW;
            end
        end
        WRITE_DONE: begin
            n_state = IDLE;
        end
        WR_ERROR: begin
            n_state = WRITE_DONE;
        end
    endcase
end

always_comb begin : output_logic_determination

    wr_master_idle_o = 0;
    wr_done_o = 0;
    set_wr_error_o = 0;
    aw_valid_o = 0;
    ld_dest_addr_o = 0;
    ld_trans_len_o = 0;
    nxt_addr_sel_o = 0;
    ld_burst_cntr_o = 0;
    burst_count_en_o = 0;
    burst_sel_o = 0;
    ld_beat_cntr_o = 0;
    beat_count_en_o = 0;
    beat_sel_o = 0;
    ld_beats_reg_o = 0;
    aw_valid_o = 0;
    w_valid_o = 0;
    ld_cur_addr_o = 0;
    cur_addr_sel_o = 0;
    rem_bytes_sel_o = 0;
    ld_rem_bytes_o = 0;
    is_first_beat_o = 0;
    fifo_rd_en_o = 0;
    b_ready_o = 0;
    str_resp_o = 0;
    rst_beat_flag_o = 1;
    set_beat_flag_o = 0;
    latch_remain_burst_done_flag_o = 0;
    rst_wr_error_o = 1;
    ld_cpu_data_o = 0;
    sel_cpu_data_o = 0;
    rst_wr_fifo_o = 0;


    case(c_state)

        IDLE: begin
            wr_master_idle_o = 1;
            rst_beat_flag_o  = 0;
            rst_wr_error_o    = 0; 
        end
        LOAD_DESC_DATA: begin
            if (cpu_op_i) begin
                ld_cpu_data_o = 1;
            end
            ld_dest_addr_o = 1;
            ld_trans_len_o = 1;
            nxt_addr_sel_o = 0;
            
        end
        LOAD: begin
            burst_sel_o     = 0;
            beat_sel_o      = 0;
            ld_burst_cntr_o = 1;
            ld_beat_cntr_o  = 1;
            ld_beats_reg_o    = 1;
            
            
        end
        SEND_AW: begin
            aw_valid_o = 1;
            if (aw_ready_i && !not_first_beat_flag_i) begin
                ld_cur_addr_o   = 1;
                cur_addr_sel_o  = 0;
                rem_bytes_sel_o = 0;
                ld_rem_bytes_o  = 1;
            end
            else if (aw_ready_i && not_first_beat_flag_i) begin
                ld_cur_addr_o   = 0;
                cur_addr_sel_o  = 1;
                rem_bytes_sel_o = 1;
                ld_rem_bytes_o  = 0;
            end
        end
        SEND_DATA: begin
            if (!not_first_beat_flag_i) begin
                is_first_beat_o = 1;
            end
            if (cpu_op_i) begin
                sel_cpu_data_o  = 1;
                w_valid_o       = 1;
                if (w_ready_i) begin
                    beat_count_en_o = 1;
                    cur_addr_sel_o  = 1;
                    rem_bytes_sel_o = 1;
                    ld_rem_bytes_o  = 1;
                    ld_cur_addr_o   = 1;
                end
            end
            if (!fifo_empty_i) begin
                w_valid_o = 1;
                if (w_ready_i) begin
                    beat_count_en_o = 1;
                    fifo_rd_en_o    = 1;
                    cur_addr_sel_o  = 1;
                    rem_bytes_sel_o = 1;
                    ld_rem_bytes_o  = 1;
                    ld_cur_addr_o   = 1;
                end
                
            end
        end
        CONTINUE_SEND: begin
            w_valid_o       = 1;
            fifo_rd_en_o    = 1;
            beat_count_en_o = 1;
            cur_addr_sel_o  = 1;
            rem_bytes_sel_o = 1;
            ld_rem_bytes_o  = 1;
            ld_cur_addr_o   = 1;
            if (cpu_op_i) begin
                sel_cpu_data_o  = 1;
                fifo_rd_en_o    = 0;
            end
            if (!w_ready_i) begin
                fifo_rd_en_o    = 0;
                beat_count_en_o = 0;
                ld_rem_bytes_o  = 0;
                ld_cur_addr_o   = 0;
            end
            else if (fifo_empty_i) begin
                w_valid_o       = 0;
                fifo_rd_en_o    = 0;
                beat_count_en_o = 0;
                ld_rem_bytes_o  = 0;
                ld_cur_addr_o   = 0;
            end
        end
        WAIT_FOR_READY: begin
            w_valid_o = 1;
            cur_addr_sel_o  = 1;
            rem_bytes_sel_o = 1;
            if (w_ready_i) begin
                fifo_rd_en_o    = 1;
                beat_count_en_o = 1;
                ld_rem_bytes_o  = 1;
                ld_cur_addr_o   = 1;
            end
        end
        WAIT_EMPTY: begin
            w_valid_o = 0;
            cur_addr_sel_o  = 1;
            rem_bytes_sel_o = 1;
            if (!fifo_empty_i) begin
                w_valid_o       = 1;
                fifo_rd_en_o    = 1;
                beat_count_en_o = 1;
                ld_rem_bytes_o  = 1;
                ld_cur_addr_o   = 1;
            end
        end
        RCV_RESP: begin
            b_ready_o = 1;
            if (b_valid_i) begin
                 str_resp_o = 1;
            end
        end
        RESP_CHECK: begin
            if (!err_i) begin
                burst_count_en_o = 1;
            end
        end
        BURST_COUNT: begin
            if (!burst_done_i) begin
                beat_sel_o      = 0;
                ld_beat_cntr_o  = 1;
                nxt_addr_sel_o  = 1;
                ld_dest_addr_o  = 1;
                set_beat_flag_o = 1;
            end
        end
        CHECK_REMAINING: begin
            if (!remaining_beats_zero_i) begin
                burst_sel_o     = 1;
                beat_sel_o      = 1;
                ld_burst_cntr_o = 1;
                ld_beat_cntr_o  = 1;
                ld_beats_reg_o    = 1;
                nxt_addr_sel_o   = 1;
                ld_dest_addr_o   = 1;
                set_beat_flag_o  = 1;
                latch_remain_burst_done_flag_o = 1; // Latch the flag to indicate that we are processing the remaining beats burst
            end
        end
        WRITE_DONE: begin
            wr_done_o = 1;
        end
        WR_ERROR: begin
            set_wr_error_o = 1;
            rst_wr_fifo_o = 1;
        end
    endcase
    
end
endmodule
