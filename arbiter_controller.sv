module arbiter_controller (
    input  logic clk,
    input  logic rst_n,
    
    // Inputs from Channels
    input  logic ch_rq_any,      // OR of all ch_req
    input  logic start_read,     // OR of all start_read
    input  logic write_start,    // OR of all write_start
    input  logic sel_type,       // From Block 2 (1 = Desc, 0 = Data)

    // Inputs from 2x1 Arbiter
    input  logic rd_master_idle,
    input  logic wr_master_idle,
    input  logic read_done_in,
    input  logic write_done_in,

    // Outputs to Datapath Blocks
    output logic sel_en,           // To Block 2
    output logic do_read_trigger,  // To Block 3
    output logic do_write_trigger, // To Block 3
    output logic resp_en,          // To Block 4
    output logic update_rr_ptr,    // To Block 1
    output logic [2:0] fsm_state   // To Block 4
);

    typedef enum logic [2:0] {
        IDLE         = 3'b000,
        LOCKED_GR    = 3'b001,
        DESC_RD      = 3'b010,
        WAIT_DATA_RD = 3'b011,
        DATA_RD      = 3'b100,
        WAIT_DATA_WR = 3'b101,
        DATA_WR      = 3'b110,
        COMPLETE     = 3'b111
    } state_t;

    state_t current_state, next_state;
    assign fsm_state = current_state;

    // State Memory
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) current_state <= IDLE;
        else        current_state <= next_state;
    end

    // Next State & Mealy Output Logic
    always_comb begin
        // Default states and outputs
        next_state       = current_state;
        sel_en           = 1'b0;
        do_read_trigger  = 1'b0;
        do_write_trigger = 1'b0;
        resp_en          = 1'b0;
        update_rr_ptr    = 1'b0;

        case (current_state)
            IDLE: begin
                if (ch_rq_any) begin
                    sel_en     = 1'b1; // Lock in the addresses
                    next_state = LOCKED_GR;
                end
            end

            LOCKED_GR: begin
                // Check if we need a descriptor or go straight to data read
                if (sel_type == 1'b1) begin
                    if (rd_master_idle) begin
                        do_read_trigger = 1'b1;
                        next_state      = DESC_RD;
                    end
                end else begin
                    next_state = WAIT_DATA_RD; // Skip desc, go straight to data
                end
            end

            DESC_RD: begin
                if (read_done_in) begin
                    resp_en    = 1'b1; // Pulse desc_valid
                    next_state = WAIT_DATA_RD;
                end
            end

            WAIT_DATA_RD: begin
                if (start_read && rd_master_idle) begin
                    do_read_trigger = 1'b1;
                    next_state      = DATA_RD;
                end
            end

            DATA_RD: begin
                if (read_done_in) begin
                    resp_en    = 1'b1; // Pulse read_done
                    next_state = WAIT_DATA_WR;
                end
            end

            WAIT_DATA_WR: begin
                if (write_start && wr_master_idle) begin
                    do_write_trigger = 1'b1;
                    next_state       = DATA_WR;
                end
            end

            DATA_WR: begin
                if (write_done_in) begin
                    resp_en    = 1'b1; // Pulse write_done
                    next_state = COMPLETE;
                end
            end

            COMPLETE: begin
                update_rr_ptr = 1'b1; // Move the pointer to next channel
                next_state    = IDLE;
            end
            
            default: next_state = IDLE;
        endcase
    end

endmodule