

module axi_master_rd_ctrl (
    input logic clk,
    input logic rst_n,
    // From Datapath
    input logic burst_done_i,
    input logic beat_done_i,
    input logic err_i,
    input logic remaining_beats_zero_i,
    input logic desc_count_done_i,
    input logic remain_burst_done_flag_i,
    input logic err_flag_i,
    // To Datapath
    output logic load_burst_cntr_o,
    output logic load_beat_cntr_o,
    output logic beat_sel_o,
    output logic beat_count_en_o,
    output logic load_beat_reg_o,
    output logic ld_desc_addr_o,
    output logic ar_addr_sel_o,
    output logic ar_len_sel_o,
    output logic burst_count_en_o,
    output logic burst_sel_o,
    output logic sample_en_o,
    output logic desc_count_en_o,
    output logic ld_desc_data_r_o,
    output logic ld_src_addr_o,
    output logic ld_trans_len_o,
    output logic nxt_addr_sel_o,
    output logic route_zeros_o,
    output logic latch_remain_burst_done_flag_o,
    output logic ld_cpu_data_o,
    // From Arbiter
    input logic start_read_i,
    input logic desc_fetch_i,
    input logic cpu_op_i,
    //input logic ch_ready_i,
    // To Arbiter
    output logic read_done_o,
    output logic rd_master_idle_o,
    output logic data_valid_o,
    //output logic read_error_o,
    // From memory_controller (AXI_signals)
    input logic ar_ready_i,
    input logic r_valid_i,
    input logic r_last_i,
    // To memory_controller (AXI_signals)
    output logic ar_valid_o,
    output logic r_ready_o,
    // FROM FIFO
    input logic fifo_full_i,
    // To FIFO
    output logic fifo_wr_en_o,
    output logic rst_rd_fifo_o
    
    
    
);
typedef enum  logic [3:0] {
    IDLE,
    LOAD_DESC_DATA,
    LOAD,
    SEND_AR,
    RCV_DATA,
    CONTINUE_RCV,
    BURST_COUNT,
    CHECK_REMAINING,
    DONE,
    LOAD_DESC_ADDR,
    RCV_DESC_DATA,
    PASS_DESC_DATA,
    WAIT_VALID,
    WAIT_FIFO,
    WAIT_DESC_VALID,
    READ_ERROR
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

always_comb begin
    case(c_state)
        IDLE: begin
            if (start_read_i && !desc_fetch_i) begin
                n_state = LOAD_DESC_DATA;
            end
            else if (start_read_i && desc_fetch_i) begin
                n_state = LOAD_DESC_ADDR;
            end
            else begin
                n_state = IDLE;
            end
        end
        LOAD_DESC_DATA: begin
            n_state = LOAD;
        end
        LOAD: begin
            n_state = SEND_AR;
        end
        SEND_AR: begin
            if (ar_ready_i) begin
                n_state = RCV_DATA;
            end
            else begin
                n_state = SEND_AR;
            end
        end
        RCV_DATA: begin
            if (r_valid_i && desc_fetch_i) begin
                n_state = RCV_DESC_DATA; 
            end
            else if (r_valid_i && !fifo_full_i) begin
                n_state = CONTINUE_RCV;
            end
            else begin
                n_state = RCV_DATA;
            end
        end
        CONTINUE_RCV: begin
            if (beat_done_i) begin // Cross checking final beat.
                n_state = BURST_COUNT;
            end
            
            else if (!r_valid_i) begin
                n_state = WAIT_VALID;
            end
            else if (fifo_full_i) begin
                n_state = WAIT_FIFO;
            end
            
            else begin
                n_state = CONTINUE_RCV;
            end
        end
        WAIT_VALID: begin
            if (r_valid_i) begin
                n_state = BURST_COUNT;
            end
            else begin
                n_state = WAIT_VALID;
            end

        end
        BURST_COUNT: begin
            if (err_flag_i) begin
                n_state = READ_ERROR;
            end
            else if (burst_done_i && remain_burst_done_flag_i) begin
                n_state = DONE;
            end
            else if (burst_done_i) begin
                n_state = CHECK_REMAINING;
            end
            else begin
                n_state = SEND_AR;
            end
        end
        CHECK_REMAINING: begin
            if (remaining_beats_zero_i) begin
                n_state = DONE;
            end
            else begin
                n_state = SEND_AR;
            end
        end
        DONE: begin
            n_state = IDLE;
        end
        LOAD_DESC_ADDR: begin
            n_state = SEND_AR;
        end
        RCV_DESC_DATA: begin
            if (desc_count_done_i) begin
                n_state = PASS_DESC_DATA;
            end
            else if (!r_valid_i) begin
                n_state = WAIT_DESC_VALID;
            end
            
            else begin
                n_state = RCV_DESC_DATA;
            end
        end
        PASS_DESC_DATA: begin
            n_state = DONE;
            
        end
        WAIT_DESC_VALID: begin
            if (r_valid_i) begin
                n_state = RCV_DESC_DATA;
            end
            else begin
                n_state = WAIT_DESC_VALID;
            end
        end
        READ_ERROR: begin
            n_state = IDLE;
        end
    endcase
end
always_comb begin
    ar_valid_o = 0;
    r_ready_o = 0;
    read_done_o = 0;
    rd_master_idle_o = 0;
    load_burst_cntr_o = 0;
    load_beat_cntr_o = 0;
    load_beat_reg_o = 0;
    beat_sel_o = 0;
    beat_count_en_o = 0;
    fifo_wr_en_o = 0;
    burst_count_en_o = 0;
    burst_sel_o = 0;
    //set_flag_o = 0;
    ld_desc_addr_o = 0;
    ar_addr_sel_o = 0;
    ar_len_sel_o = 0;
    sample_en_o = 0;
    desc_count_en_o = 0;
    ld_desc_data_r_o = 0;
    data_valid_o = 0;
    ld_src_addr_o =  0;
    ld_trans_len_o = 0;
    nxt_addr_sel_o = 0;
    route_zeros_o = 0;
    //read_error_o = 0;
    latch_remain_burst_done_flag_o = 0;
    rst_rd_fifo_o = 0;
    ld_cpu_data_o = 0;
    
    case(c_state)
    IDLE: begin
        // Default values are already set above
        rd_master_idle_o = 1; 
    end
    LOAD_DESC_DATA: begin
        ld_src_addr_o = 1;
        ld_trans_len_o = 1;
        nxt_addr_sel_o = 0;
    end
    LOAD: begin
        load_burst_cntr_o = 1;
        load_beat_cntr_o = 1;
        load_beat_reg_o = 1;
        beat_sel_o = 0;
        burst_sel_o = 0;
    end
    SEND_AR: begin
        ar_valid_o = 1;
        ar_addr_sel_o = 0; 
        ar_len_sel_o = 0;
        if (desc_fetch_i) begin
            ar_addr_sel_o = 1; 
            ar_len_sel_o = 1;  
        end
    end
    RCV_DATA: begin
        if (desc_fetch_i) begin
            r_ready_o = 1;
            if (r_valid_i) begin
                desc_count_en_o = 1;
                sample_en_o = 1;
            end
        end
        else if (cpu_op_i)  begin 
            r_ready_o = 1;
            if (r_valid_i) begin
                beat_count_en_o = 1;
                ld_cpu_data_o   = 1;
                if (beat_done_i) begin
                    beat_count_en_o = 0;
                end
                if (err_i) begin
                    route_zeros_o = 1;
                end
            end
        end
        else if (!fifo_full_i)  begin 
            r_ready_o = 1;
            if (r_valid_i) begin
                beat_count_en_o = 1;
                fifo_wr_en_o = 1;
                if (beat_done_i) begin
                    beat_count_en_o = 0;
                end
                if (err_i) begin
                    route_zeros_o = 1;
                end
            end
        end
        
    end
    CONTINUE_RCV: begin
        beat_count_en_o = 1;
        fifo_wr_en_o    = 1;
        r_ready_o = 1;
        if (err_i) begin
            route_zeros_o = 1;
        end
        if (fifo_full_i) begin
            r_ready_o =       0;
            beat_count_en_o = 0;
            fifo_wr_en_o    = 0;
        end
        if (beat_done_i) begin
            burst_count_en_o = 1;
        end
        if (!r_valid_i) begin
            beat_count_en_o = 0;
            fifo_wr_en_o    = 0;
        end
        
    end
    WAIT_VALID: begin
        r_ready_o       = 1;
        fifo_wr_en_o    = 0;
        beat_count_en_o = 0;
        if (r_valid_i) begin
            beat_count_en_o = 1;
            fifo_wr_en_o    = 1;
        end
    end
    WAIT_FIFO: begin
        r_ready_o       = 0;
        fifo_wr_en_o    = 0;
        beat_count_en_o = 0;
        if (!fifo_full_i) begin
            beat_count_en_o = 1;
            fifo_wr_en_o    = 1;
            r_ready_o       = 1;
        end
    end
    BURST_COUNT: begin
        if (!burst_done_i) begin
            beat_sel_o = 0;
            load_beat_cntr_o = 1;
            nxt_addr_sel_o = 1;   // For next AR addr to be from updated src addr
            ld_src_addr_o = 1;
        end
    end
    CHECK_REMAINING: begin
        if (!remaining_beats_zero_i) begin
            burst_sel_o = 1;      // Select the last burst with remaining beats
            beat_sel_o = 1;       // Load the beat counter with remaining beats
            nxt_addr_sel_o = 1;   // For next AR addr to be from updated src addr
            ld_src_addr_o = 1;
            load_beat_cntr_o = 1; // Load the beat counter with remaining beats
            load_beat_reg_o = 1;
            load_burst_cntr_o = 1; // Load the burst counter with number of remaining burst = 1
            latch_remain_burst_done_flag_o = 1; // Latch the flag to indicate that we are processing the remaining beats burst
        end
    end
    DONE: begin
        read_done_o = 1;
        data_valid_o = 1;
    end
    LOAD_DESC_ADDR: begin
        ld_desc_addr_o = 1;
    end
    RCV_DESC_DATA: begin
        sample_en_o         = 1;
        desc_count_en_o     = 1;
        r_ready_o           = 1;
        if (err_i) begin
            route_zeros_o = 1;
        end
        if (desc_count_done_i) begin
            sample_en_o         = 0;
            desc_count_en_o     = 0;
            ld_desc_data_r_o    = 1;
        end
        else if (!r_valid_i) begin
            sample_en_o         = 0;
            desc_count_en_o     = 0;   
        end
        
    end
    PASS_DESC_DATA: begin
        data_valid_o = 1;
    end
    WAIT_DESC_VALID: begin
        r_ready_o        = 1;
        if (r_valid_i) begin
            sample_en_o         = 1;
            desc_count_en_o     = 1;
        end
    end
    READ_ERROR: begin
        rst_rd_fifo_o = 1;
    end
    endcase
    
end
endmodule