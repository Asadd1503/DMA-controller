
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
    //output logic [3:0] fsm_state   // To Block 4
    output logic route_desc,
    output logic route_read,
    output logic route_write
);

    typedef enum logic [3:0] {
        IDLE         = 4'b0000,
        LOCKED_GR    = 4'b0001,
        DESC_RD      = 4'b0010,
        WAIT_DATA_RD = 4'b0011,
        DATA_RD      = 4'b0100,
        WAIT_DATA_WR = 4'b0101,
        DATA_WR      = 4'b0110,
        COMPLETE     = 4'b0111,
        REQ_SEL      = 4'b1000,
        PASS_ERRORS  = 4'b1001
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
        route_desc       = 1'b0;
        route_read       = 1'b0;
        route_write      = 1'b0;

        case (current_state)
            IDLE: begin
                if (ch_rq_any) begin
                next_state = REQ_SEL;
                    
                end
            end
            REQ_SEL: begin
                next_state = LOCKED_GR;
                sel_en     = 1'b1; // Lock in the addresses
            end

            LOCKED_GR: begin
                // Check if we need a descriptor or go straight to data read
                //sel_en = 1'b1; 
                sel_en = 1'b1;
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
                //sel_en = 1'b1; // Keep the selection locked until we get the descriptor
                if (read_done_in) begin
                    resp_en    = 1'b1; // Pulse desc_valid
                    route_desc = 1'b1;
                    next_state = WAIT_DATA_RD;
                end
            end

            WAIT_DATA_RD: begin
                sel_en = 1'b1; // Keep the selection locked while waiting for data read
                if (start_read && rd_master_idle) begin
                    do_read_trigger = 1'b1;
                    next_state      = DATA_RD;
                end
                if (write_start && wr_master_idle) begin
                    do_write_trigger = 1'b1;
                    //next_state       = DATA_WR;
                end
            end

            DATA_RD: begin
                if (read_done_in) begin
                    resp_en    = 1'b1; // Pulse read_done
                    route_read = 1'b1;
                    next_state = DATA_WR;
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
                    route_write = 1'b1;
                    next_state = PASS_ERRORS;
                end
            end
            PASS_ERRORS: begin
                resp_en    = 1'b1; 
                next_state = COMPLETE;
            end
            COMPLETE: begin
                update_rr_ptr = 1'b1; // Move the pointer to next channel
                next_state    = IDLE;
            end
            
            default: next_state = IDLE;
        endcase
    end
    

endmodule