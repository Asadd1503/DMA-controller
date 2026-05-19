module dma_fsm (
    input  logic         clk,
    input  logic         rst_n,

    input  logic         ch_en,
    input  logic [31 :0] desc_ptr,
    input  logic         ch_abort,
    input  logic         desc_valid,
    input  logic         grant,
    input  logic         read_done,
    input  logic         write_done,
    input  logic         write_error,
    input  logic         read_error,
    input  logic [127:0] desc_data,

    output logic         ch_done,
    output logic         busy,
    output logic         ch_req,
    output logic         start_read,
    output logic         start_write,
    output logic [31 :0] src_addr,
    output logic [31 :0] dest_addr,
    output logic [31 :0] len_and_flag,
    output logic         desc_fetch,
    output logic [31 :0] desc_addr,
    output logic [1  :0] response_status 
);

    // Internal Registers
    logic [31 :0] nxt_desc_reg;
    logic         ch_abort_reg;
    logic [31 :0] src_addr_reg;
    logic [31 :0] dest_addr_reg;
    logic [31 :0] len_and_flag_reg;
    logic [1  :0] response_reg;

    typedef enum logic [2 : 0] {
        IDLE,
        REQUEST,
        FETCH_DESC,
        DECODE_DESC,
        START_TRANSACTION,
        RESPONSE,           
        ABORT
    } state_t;

    state_t current_state, next_state;

    // =========================================================================
    // 1. SEQUENTIAL LOGIC: State & Data Registers
    // =========================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state    <= IDLE;
            nxt_desc_reg     <= '0;
            ch_abort_reg     <= '0;
            src_addr_reg     <= '0;
            dest_addr_reg    <= '0;
            len_and_flag_reg <= '0;
            response_reg     <= '0;
        end else begin
            current_state <= next_state;

            case (current_state)
                IDLE: begin
                    ch_abort_reg <= '0; 
                    response_reg    <= '0; 
                end
                REQUEST: begin
                    nxt_desc_reg <= desc_ptr;
                end
                FETCH_DESC: begin
                    if (ch_abort) ch_abort_reg <= 1'b1;
                end
                DECODE_DESC: begin
                    src_addr_reg     <= desc_data[31 : 0];
                    dest_addr_reg    <= desc_data[63 :32];
                    len_and_flag_reg <= desc_data[95 :64];
                    nxt_desc_reg     <= desc_data[127:96];
                    

                    response_reg     <= 2'b00; 
                end
                START_TRANSACTION: begin
                    if (read_error)  response_reg[0] <= 1'b1;
                    if (write_error) response_reg[1] <= 1'b1;
                end
            endcase
        end
    end

    // =========================================================================
    // 2. COMBINATIONAL LOGIC: Next State
    // =========================================================================
    always_comb begin
        next_state = current_state; 

        case (current_state)
            IDLE: begin
                if (ch_en) next_state = REQUEST;
            end
            REQUEST: begin
                if (ch_abort) next_state = ABORT;
                else if (grant) next_state = FETCH_DESC;
            end
            FETCH_DESC: begin
                if (ch_abort) next_state = ABORT; 
                else if (desc_valid) next_state = DECODE_DESC;
            end
            DECODE_DESC: begin
                if (ch_abort || ch_abort_reg) next_state = ABORT;
                else next_state = START_TRANSACTION;
            end
            START_TRANSACTION: begin
                if (ch_abort) begin
                    next_state = ABORT;
                end 
                else if (read_done && write_done) begin
                    next_state = RESPONSE; 
                end
            end
            RESPONSE: begin
                if (!len_and_flag_reg[25]) next_state = REQUEST;
                else next_state = IDLE;
            end
            ABORT: begin
                next_state = IDLE;
            end
        endcase
    end

    // =========================================================================
    // 3. COMBINATIONAL LOGIC: Outputs
    // =========================================================================
    always_comb begin
        // 1. DEFINE DEFAULTS
        ch_done         = 1'b0;
        busy            = 1'b1; 
        ch_req          = 1'b0;
        start_read      = 1'b0;
        start_write     = 1'b0;
        desc_fetch      = 1'b0;
        
        src_addr        = src_addr_reg;
        dest_addr       = dest_addr_reg;
        len_and_flag    = len_and_flag_reg;
        desc_addr       = nxt_desc_reg;
        
        response_status = response_reg;

        case (current_state)
            IDLE: begin
                busy = 1'b0;
            end
            REQUEST: begin
                ch_req = 1'b1;
            end
            FETCH_DESC: begin
                desc_fetch = 1'b1;
            end
            START_TRANSACTION: begin
                if (!read_done)  start_read  = 1'b1;
                if (!write_done) start_write = 1'b1;
            end
            RESPONSE: begin


                if (len_and_flag_reg[25]) begin
                    ch_done = 1'b1;
                    busy    = 1'b0;
                end
            end
            ABORT: begin
                ch_done = 1'b1;
                busy    = 1'b0;
            end
        endcase
    end

endmodule