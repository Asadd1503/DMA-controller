
module dma_reg_top #(
    parameter int N = 4
)(
    // clock and reset
    input  logic        aclk,
    input  logic        rst_n,

    // AXI-4 Lite CPU-facing signals (write address channel)
    input  logic [31:0] awaddr,
    input  logic        awvalid,
    output logic        awready,

    // AXI-4 Lite CPU-facing signals (write data channel)
    input  logic [31:0] wdata,
    input  logic [3:0]  wstrb,
    input  logic        wvalid,
    output logic        wready,

    // AXI-4 Lite CPU-facing signals (write response channel)
    output logic [1:0]  bresp,
    output logic        bvalid,
    input  logic        bready,

    // AXI-4 Lite CPU-facing signals (read address channel)
    input  logic [31:0] araddr,
    input  logic        arvalid,
    output logic        arready,

    // AXI-4 Lite CPU-facing signals (read data channel)
    output logic [31:0] rdata,
    output logic [1:0]  rresp,
    output logic        rvalid,
    input  logic        rready,

    // outputs to channel FSMs
    output logic [N-1:0]        ch_en_o,
    output logic [31:0]         desc_ptr_o [0:N-1],
    output logic [1:0]          err_resp_o [0:N-1],  // CPU's error response forwarded to FSM
    output logic [N-1:0]        ch_abort_o ,          // CPU abort bit forwarded to FSM

    // inputs from channel FSMs
    input  logic [1:0]          error_i    [0:N-1],
    input  logic [N-1:0]        done_i,
    input  logic [N-1:0]        resp_valid_i,     // channel says: I have an error to report
    input  logic [N-1:0]        busy_i,

    // interrupt output to CPU
    output logic [N-1:0]        irq_o,
    output logic [N-1:0]        err_irq_o      // error interrupt to CPU
);

// ── interface instantiation ───────────────────────────────────
    axi4_lite_if axi_if (
        .aclk  (aclk),
        .rst_n (rst_n)
    );

    // connect flat top-level AXI ports into the interface
    // write address channel
    assign axi_if.awaddr  = awaddr;
    assign axi_if.awvalid = awvalid;
    assign awready        = axi_if.awready;

    // write data channel
    assign axi_if.wdata   = wdata;
    assign axi_if.wstrb   = wstrb;
    assign axi_if.wvalid  = wvalid;
    assign wready         = axi_if.wready;

    // write response channel
    assign bresp          = axi_if.bresp;
    assign bvalid         = axi_if.bvalid;
    assign axi_if.bready  = bready;

    // read address channel
    assign axi_if.araddr  = araddr;
    assign axi_if.arvalid = arvalid;
    assign arready        = axi_if.arready;

    // read data channel
    assign rdata          = axi_if.rdata;
    assign rresp          = axi_if.rresp;
    assign rvalid         = axi_if.rvalid;
    assign axi_if.rready  = rready;




    // ── internal bus wires (slave → register_file) ───────────────
    logic [$clog2(1+N+N)-1:0]  reg_index;
    logic [31:0]                wdata_rf;
    logic [3:0]                 wstrb_rf;
    logic                       wen;
    logic                       ren;
    logic [31:0]                rdata_rf;



    // ── AXI-4 Lite slave instantiation ───────────────────────────
    axi4_lite_slave #(
        .N (N)
    ) u_axi_slave (
        .axi_if      (axi_if),

        .reg_index_o (reg_index),
        .wdata_o     (wdata_rf),
        .wstrb_o     (wstrb_rf),
        .wen_o       (wen),
        .ren_o       (ren),
        .rdata_i     (rdata_rf)
    );





    // ── register file instantiation ──────────────────────────────
    register_file #(
        .N (N)
    ) u_reg_file (
        .aclk        (aclk),
        .rst_n       (rst_n),

        // internal bus from slave
        .reg_index   (reg_index),
        .wdata       (wdata_rf),
        .wstrb       (wstrb_rf),
        .wen         (wen),
        .ren         (ren),
        .rdata       (rdata_rf),

        // outputs to channel FSMs
        .ch_en_o     (ch_en_o),
        .desc_ptr_o  (desc_ptr_o),

        // inputs from channel FSMs
        .error_i     (error_i),
        .done_i      (done_i),
        .busy_i      (busy_i),

        // interrupt output
        .irq_o       (irq_o),
        .resp_valid_i (resp_valid_i),
        .err_irq_o    (err_irq_o),
        .err_resp_o   (err_resp_o),
       .ch_abort_o    (ch_abort_o)
    );

endmodule