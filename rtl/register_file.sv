module register_file #(
    parameter int N = 4
)(
    // clock and reset
    input  logic                        aclk,
    input  logic                        rst_n,

    // internal bus from AXI-4 Lite slave
    input  logic [$clog2(1+N+N)-1:0]   reg_index,
    input  logic [31:0]                 wdata,
    input  logic [3:0]                  wstrb,
    input  logic                        wen,
    input  logic                        ren,
    output logic [31:0]                 rdata,

    // outputs to channel FSMs
    output logic [N-1:0]                ch_en_o,
    output logic [31:0]                 desc_ptr_o [0:N-1],

    // inputs from channel FSMs
    input  logic [1:0]                  error_i    [0:N-1],
    input  logic [N-1:0]                done_i,
    input  logic [N-1:0]                busy_i,

    // interrupt output to CPU
    output logic [N-1:0]                irq_o
);
// register map constants
    localparam int REG_COUNT  = 1 + N + N;
    localparam int WORD_BYTES = 4;
    localparam int ADDR_LSB   = 2;

    // register indices — self-documenting
    localparam int IDX_CH_EN       = 0;
    localparam int IDX_DESC_PTR_0  = 1;           // DESC_PTR[n] = 1+n
    localparam int IDX_STATUS_0    = N + 1;        // STATUS[n]  = N+1+n

    // writable flags — STATUS regs are RO from CPU side
    logic [REG_COUNT-1:0] reg_is_writable;

    
    logic [31:0] register_bank [0:N];             // index 0 to N  (N+1 entries)
    logic [31:0] status_reg    [0:N-1];           // index 0 to N-1


    //  combinational output wiring
    assign ch_en_o = register_bank[IDX_CH_EN][N-1:0];

    generate
        for (genvar n = 0; n < N; n++) begin
            assign desc_ptr_o[n] = register_bank[IDX_DESC_PTR_0 + n];
        end
    endgenerate



    // ── read MUX — combinational ─────────────────────────────────
    always_comb begin
        rdata = 32'h0;
        if (ren) begin
            if (reg_index <= N) begin
                // CH_EN or DESC_PTR — serve from register_bank
                rdata = register_bank[reg_index];
            end else if (reg_index >= IDX_STATUS_0 &&
                         reg_index < IDX_STATUS_0 + N) begin
                // STATUS — serve from status_reg
                rdata = status_reg[reg_index - IDX_STATUS_0];
            end else begin
                // out of range
                rdata = 32'hDEAD_BEEF;
            end
        end
    end
    
    
    
    always_ff @(posedge aclk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i <= N; i++)
                register_bank[i] <= 32'h0;

            reg_is_writable    <= '0;
            
            for (int i = 0; i <= N; i++)
                reg_is_writable[i] <= 1'b1;
            // STATUS indices N+1..2N stay 0 = not
            

        end else begin
            if (wen && reg_index <= N && reg_is_writable[reg_index]) begin
                // byte-lane write using wstrb
                for (int b = 0; b < 4; b++) begin
                    if (wstrb[b])
                        register_bank[reg_index][8*b +: 8] <= wdata[8*b +: 8];
                end
            end
        end
    end

    // ── status capture (W1C + hardware set) ──────────────────────
    always_ff @(posedge aclk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i < N; i++)
                status_reg[i] <= 32'h0;

        end else begin
            for (int i = 0; i < N; i++) begin

                if (wen &&
                    reg_index == ($clog2(REG_COUNT)'(IDX_STATUS_0 + i))) begin
                    // CPU write-1-to-clear — clear bits where wdata=1
                    status_reg[i] <= status_reg[i] & ~wdata;

                end else begin
                    
                    if (error_i[i] != 2'b00)
                        status_reg[i][1:0] <= status_reg[i][1:0] | error_i[i];

                    
                    if (done_i[i])
                        status_reg[i][2] <= 1'b1;

                    
                    status_reg[i][3] <= busy_i[i];
                end

            end
        end
    end
    // ── IRQ generator ─────────────────────────────────────────────
    always_ff @(posedge aclk or negedge rst_n) begin
        if (!rst_n) begin
            irq_o <= '0;
        end else begin
            irq_o <= done_i;
        end
    end

endmodule
/*
Suppose current register value = 0x11223344
Bytes: b3=0x11, b2=0x22, b1=0x33, b0=0x44

axi_if.wdata = 32'hAABBCCDD
Bytes: b3=0xAA, b2=0xBB, b1=0xCC, b0=0xDD

wstrb = 4'b0101 (b3 b2 b1 b0 = 0 1 0 1)

Loop behavior:

b=0: wstrb[0]=1 → update byte0 to 0xDD

b=1: wstrb[1]=0 → keep byte1 = 0x33

b=2: wstrb[2]=1 → update byte2 to 0xBB

b=3: wstrb[3]=0 → keep byte3 = 0x11

Resulting register = bytes (b3 b2 b1 b0) = 0x11 BB 33 DD → 0x11BB33DD.




Right now your W_DATA state writes directly into register_bank. The STATUS registers are being written by two drivers — the h
ardware (error/done inputs) and the W1C clear path. In SystemVerilog you cannot have two always_ff blocks both writing the same register
 variable. So you have two clean options: either handle everything in one combined always_ff block with priority (hardware set takes
  priority, CPU clear second), or use an intermediate status_reg array that is separate from register_bank and only gets mirrored into 
  register_bank combinationally for reads. The second option is cleaner because it keeps your existing write FSM block untouched — t
  he read MUX just picks status_reg[n] instead of register_bank[N+1+n] when the address falls in the STATUS range.
*/