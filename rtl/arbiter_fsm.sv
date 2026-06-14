

module arbiter_fsm (
    input  logic clk,
    input  logic rst_n,

    // --- Requesters ---
    input  logic read_req,       // CPU
    input  logic write_req,      // CPU
    input  logic start_read_i,   // DMA
    input  logic start_write_i,  // DMA
    input logic desc_fetch_i,   // DMA

    // --- Done Signals (From DONE_ROUTER) ---
    input  logic c_read_done,
    input  logic c_write_done,
    input  logic d_read_done,
    input  logic d_write_done,

    // --- Outputs ---
    output logic rm_req,
    output logic wm_req,
    output logic sel_cpu_r,
    output logic sel_cpu_w,
    output logic sel_dma_r,
    output logic sel_dma_w,
    output logic cpu_op_o
);

    // FSM State Encoding
    typedef enum logic [2:0] {
        ST_IDLE             = 3'b000,
        ST_CPU_READ         = 3'b001,
        ST_CPU_WRITE        = 3'b010,
        ST_DMA_READ         = 3'b011,
        ST_DMA_READ_WRITE   = 3'b100,
        WAIT_READ_WRITE     = 3'b101
    } state_t;

    state_t current_state, next_state;

    // State Transition (Sequential)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= ST_IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next State Logic (Combinational)
    always_comb begin
        next_state = current_state; // Default stay in current state

        case (current_state)
            ST_IDLE: begin
                // Strict Priority Evaluation
                if      (read_req)                      next_state = ST_CPU_READ;
                else if (write_req)                     next_state = ST_CPU_WRITE;
                else if (start_read_i && start_write_i) next_state = ST_DMA_READ_WRITE;
                else if (start_read_i || desc_fetch_i)  next_state = ST_DMA_READ;
                
            end

            ST_CPU_READ: begin
                if (c_read_done) next_state = ST_IDLE;
            end

            ST_CPU_WRITE: begin
                if (c_write_done) next_state = ST_IDLE;
            end

            ST_DMA_READ: begin
                if (d_read_done) next_state = ST_IDLE;
            end

            ST_DMA_READ_WRITE: begin
                next_state = WAIT_READ_WRITE;
            end
            WAIT_READ_WRITE: begin
                if (d_write_done) next_state = ST_IDLE;
            end
            
            default: next_state = ST_IDLE;
        endcase
    end

    // Output Logic (Moore Machine - purely based on current_state)
    always_comb begin
        // Default outputs to 0
        rm_req    = 1'b0;
        wm_req    = 1'b0;
        sel_cpu_r = 1'b0;
        sel_cpu_w = 1'b0;
        sel_dma_r = 1'b0;
        sel_dma_w = 1'b0;
        cpu_op_o = 1'b0;

        case (current_state)
            ST_CPU_READ: begin
                rm_req    = 1'b1;
                sel_cpu_r = 1'b1;
                cpu_op_o  = 1'b1; // Indicate CPU operation
            end
            ST_CPU_WRITE: begin
                wm_req    = 1'b1;
                sel_cpu_w = 1'b1;
                cpu_op_o  = 1'b1; // Indicate CPU operation
            end
            ST_DMA_READ: begin
                rm_req    = 1'b1;
                sel_dma_r = 1'b1;
            end
            ST_DMA_READ_WRITE: begin
                rm_req    = 1'b1;
                sel_dma_r = 1'b1;
                wm_req    = 1'b1;
                sel_dma_w = 1'b1;
            end
            WAIT_READ_WRITE: begin
                sel_dma_r = 1'b1; // keep dma selected but pull wm and rm req low
                sel_dma_w = 1'b1;
            end
            // ST_IDLE remains all 0s
        endcase
    end

endmodule