`timescale 1ns/1ps

module tb_dma_reg_top;

    // ───────────────────────────────────────────────
    // Parameters
    // ───────────────────────────────────────────────
    localparam int N        = 4;
    localparam int CLK_HALF = 5;   // 10 ns clock period

    // base address + register offsets
    localparam logic [31:0] BASE       = 32'h0000_0000;
    localparam logic [31:0] ADDR_CHEN  = BASE + 32'h00;           // CH_EN
    localparam logic [31:0] ADDR_DP0   = BASE + 32'h04;           // DESC_PTR[0]
    localparam logic [31:0] ADDR_DP1   = BASE + 32'h08;           // DESC_PTR[1]
    localparam logic [31:0] ADDR_DP2   = BASE + 32'h0C;           // DESC_PTR[2]
    localparam logic [31:0] ADDR_DP3   = BASE + 32'h10;           // DESC_PTR[3]
    localparam logic [31:0] ADDR_ST0   = BASE + 32'h14;           // STATUS[0]
    localparam logic [31:0] ADDR_ST1   = BASE + 32'h18;           // STATUS[1]
    localparam logic [31:0] ADDR_ST2   = BASE + 32'h1C;           // STATUS[2]
    localparam logic [31:0] ADDR_ST3   = BASE + 32'h20;           // STATUS[3]
    localparam logic [31:0] ADDR_OOB   = BASE + 32'hFF;           // out-of-range

    // ───────────────────────────────────────────────
    // DUT signals
    // ───────────────────────────────────────────────
    logic        aclk, rst_n;

    // AXI write address channel
    logic [31:0] awaddr;
    logic        awvalid, awready;

    // AXI write data channel
    logic [31:0] wdata;
    logic [3:0]  wstrb;
    logic        wvalid, wready;

    // AXI write response channel
    logic [1:0]  bresp;
    logic        bvalid, bready;

    // AXI read address channel
    logic [31:0] araddr;
    logic        arvalid, arready;

    // AXI read data channel
    logic [31:0] rdata;
    logic [1:0]  rresp;
    logic        rvalid, rready;

    // channel FSM side
    logic [N-1:0]      ch_en_o;
    logic [31:0]       desc_ptr_o [0:N-1];
    logic [1:0]        error_i    [0:N-1];
    logic [N-1:0]      done_i;
    logic [N-1:0]      busy_i;
    logic [N-1:0]      irq_o;

    // ───────────────────────────────────────────────
    // DUT instantiation
    // ───────────────────────────────────────────────
    dma_reg_top #(.N(N)) dut (
        .aclk       (aclk),
        .rst_n      (rst_n),
        .awaddr     (awaddr),
        .awvalid    (awvalid),
        .awready    (awready),
        .wdata      (wdata),
        .wstrb      (wstrb),
        .wvalid     (wvalid),
        .wready     (wready),
        .bresp      (bresp),
        .bvalid     (bvalid),
        .bready     (bready),
        .araddr     (araddr),
        .arvalid    (arvalid),
        .arready    (arready),
        .rdata      (rdata),
        .rresp      (rresp),
        .rvalid     (rvalid),
        .rready     (rready),
        .ch_en_o    (ch_en_o),
        .desc_ptr_o (desc_ptr_o),
        .error_i    (error_i),
        .done_i     (done_i),
        .busy_i     (busy_i),
        .irq_o      (irq_o)
    );

    // ───────────────────────────────────────────────
    // Clock generation
    // ───────────────────────────────────────────────
    initial aclk = 0;
    always #CLK_HALF aclk = ~aclk;

    // ───────────────────────────────────────────────
    // Test result tracking
    // ───────────────────────────────────────────────
    int pass_count = 0;
    int fail_count = 0;

    task check(
        input string  test_name,
        input logic   condition
    );
        if (condition) begin
            $display("PASS : %s", test_name);
            pass_count++;
        end else begin
            $display("FAIL : %s", test_name);
            fail_count++;
        end
    endtask

    // ───────────────────────────────────────────────
    // AXI write task
    // drives a single 32-bit AXI-4 Lite write
    // ───────────────────────────────────────────────
    task axi_write(
        input logic [31:0] addr,
        input logic [31:0] data,
        input logic [3:0]  strb = 4'hF
    );
        // write address phase
        @(negedge aclk);
        awaddr  = addr;
        awvalid = 1'b1;
        wdata   = data;
        wstrb   = strb;
        wvalid  = 1'b1;
        bready  = 1'b1;

        // wait for awready
        @(posedge aclk);
        while (!awready) @(posedge aclk);

        @(negedge aclk);
        awvalid = 1'b0;

        // wait for wready
        @(posedge aclk);
        while (!wready) @(posedge aclk);

        @(negedge aclk);
        wvalid = 1'b0;

        // wait for bvalid
        @(posedge aclk);
        while (!bvalid) @(posedge aclk);

        @(negedge aclk);
        bready = 1'b0;

        @(posedge aclk);
    endtask

    // ───────────────────────────────────────────────
    // AXI read task
    // drives a single 32-bit AXI-4 Lite read
    // result captured in rd_data
    // ───────────────────────────────────────────────
    task axi_read(
        input  logic [31:0] addr,
        output logic [31:0] rd_data,
        output logic [1:0]  rd_resp
    );
        @(negedge aclk);
        araddr  = addr;
        arvalid = 1'b1;
        rready  = 1'b1;

        // wait for arready
        @(posedge aclk);
        while (!arready) @(posedge aclk);

        @(negedge aclk);
        arvalid = 1'b0;

        // wait for rvalid
        @(posedge aclk);
        while (!rvalid) @(posedge aclk);

        rd_data = rdata;
        rd_resp = rresp;

        @(negedge aclk);
        rready  = 1'b0;

        @(posedge aclk);
    endtask

    // ───────────────────────────────────────────────
    // AXI write and capture bresp
    // ───────────────────────────────────────────────
    task axi_write_resp(
        input  logic [31:0] addr,
        input  logic [31:0] data,
        output logic [1:0]  wr_resp
    );
        @(negedge aclk);
        awaddr  = addr;
        awvalid = 1'b1;
        wdata   = data;
        wstrb   = 4'hF;
        wvalid  = 1'b1;
        bready  = 1'b1;

        @(posedge aclk);
        while (!awready) @(posedge aclk);

        @(negedge aclk);
        awvalid = 1'b0;

        @(posedge aclk);
        while (!wready) @(posedge aclk);

        @(negedge aclk);
        wvalid = 1'b0;

        @(posedge aclk);
        while (!bvalid) @(posedge aclk);

        wr_resp = bresp;

        @(negedge aclk);
        bready = 1'b0;

        @(posedge aclk);
    endtask

    // ───────────────────────────────────────────────
    // Main test sequence
    // ───────────────────────────────────────────────
    logic [31:0] rd_data;
    logic [1:0]  rd_resp;
    logic [1:0]  wr_resp;
    logic        irq_seen;
    int          irq_wait;

    initial begin

        // ── initialise all driven signals ──────────
        awaddr  = '0;  awvalid = 0;
        wdata   = '0;  wstrb   = '0;  wvalid  = 0;
        bready  = 0;
        araddr  = '0;  arvalid = 0;
        rready  = 0;
        done_i  = '0;
        busy_i  = '0;
        for (int i = 0; i < N; i++) error_i[i] = 2'b00;

        // ── reset ──────────────────────────────────
        rst_n = 1'b0;
        repeat(4) @(posedge aclk);
        @(negedge aclk);
        rst_n = 1'b1;
        repeat(2) @(posedge aclk);

        // ════════════════════════════════════════════
        // TEST 1 — write CH_EN, check ch_en_o updates
        // ════════════════════════════════════════════
        axi_write(ADDR_CHEN, 32'h0000_000B); // enable channels 0,1,3
        @(posedge aclk);
        check("T1: ch_en_o matches written value",
              ch_en_o == 4'b1011);

        // ════════════════════════════════════════════
        // TEST 2 — write all DESC_PTR, check outputs
        // ════════════════════════════════════════════
        axi_write(ADDR_DP0, 32'hAAAA_0000);
        axi_write(ADDR_DP1, 32'hBBBB_1111);
        axi_write(ADDR_DP2, 32'hCCCC_2222);
        axi_write(ADDR_DP3, 32'hDDDD_3333);
        @(posedge aclk);
        check("T2a: desc_ptr_o[0] correct", desc_ptr_o[0] == 32'hAAAA_0000);
        check("T2b: desc_ptr_o[1] correct", desc_ptr_o[1] == 32'hBBBB_1111);
        check("T2c: desc_ptr_o[2] correct", desc_ptr_o[2] == 32'hCCCC_2222);
        check("T2d: desc_ptr_o[3] correct", desc_ptr_o[3] == 32'hDDDD_3333);

        // ════════════════════════════════════════════
        // TEST 3 — read back CH_EN and DESC_PTR[0]
        // ════════════════════════════════════════════
        axi_read(ADDR_CHEN, rd_data, rd_resp);
        check("T3a: CH_EN readback correct",
              rd_data[N-1:0] == 4'b1011 && rd_resp == 2'b00);

        axi_read(ADDR_DP0, rd_data, rd_resp);
        check("T3b: DESC_PTR[0] readback correct",
              rd_data == 32'hAAAA_0000 && rd_resp == 2'b00);

        axi_read(ADDR_DP3, rd_data, rd_resp);
        check("T3c: DESC_PTR[3] readback correct",
              rd_data == 32'hDDDD_3333 && rd_resp == 2'b00);

        // ════════════════════════════════════════════
        // TEST 4 — status capture
        // pulse error_i[0], then read STATUS[0]
        // ════════════════════════════════════════════
        @(negedge aclk);
        error_i[0] = 2'b01;
        @(posedge aclk);
        @(negedge aclk);
        error_i[0] = 2'b00;          // remove — W1C so bit stays set

        // pulse done_i[0]
        done_i[0] = 1'b1;
        @(posedge aclk);
        @(negedge aclk);
        done_i[0] = 1'b0;

        // pulse busy_i[1] as level
        busy_i[1] = 1'b1;
        @(posedge aclk);

        // read STATUS[0] — expect error[1:0]=01, done=1
        axi_read(ADDR_ST0, rd_data, rd_resp);
        check("T4a: STATUS[0] error bits set",   rd_data[1:0] == 2'b01);
        check("T4b: STATUS[0] done bit set",     rd_data[2]   == 1'b1);
        check("T4c: STATUS[0] rresp is OKAY",    rd_resp      == 2'b00);

        // read STATUS[1] — expect busy=1
        axi_read(ADDR_ST1, rd_data, rd_resp);
        check("T4d: STATUS[1] busy bit set",     rd_data[3]   == 1'b1);

        // ════════════════════════════════════════════
        // TEST 5 — W1C clear
        // write 1s to error and done bits of STATUS[0]
        // ════════════════════════════════════════════
        axi_write(ADDR_ST0, 32'h0000_0007); // clear bits [2:0]
        @(posedge aclk);
        axi_read(ADDR_ST0, rd_data, rd_resp);
        check("T5a: STATUS[0] error cleared",    rd_data[1:0] == 2'b00);
        check("T5b: STATUS[0] done cleared",     rd_data[2]   == 1'b0);

        // clear busy on channel 1
        busy_i[1] = 1'b0;
        @(posedge aclk);
        axi_read(ADDR_ST1, rd_data, rd_resp);
        check("T5c: STATUS[1] busy cleared",     rd_data[3]   == 1'b0);

        // ════════════════════════════════════════════
        // TEST 6 — IRQ pulse
        // pulse done_i[2], watch irq_o[2] for 1 cycle
        // ════════════════════════════════════════════
        irq_seen  = 1'b0;
        irq_wait  = 0;

        @(negedge aclk);
        done_i[2] = 1'b1;
        @(posedge aclk);
        @(negedge aclk);
        done_i[2] = 1'b0;

        // IRQ is registered — appears one cycle after done_i
        // check for exactly one cycle high within next 3 cycles
        repeat(3) begin
            @(posedge aclk);
            if (irq_o[2]) begin
                irq_seen = 1'b1;
                irq_wait++;
            end
        end
        check("T6a: irq_o[2] fired",             irq_seen == 1'b1);
        check("T6b: irq_o[2] only 1 cycle high", irq_wait == 1);

        // ════════════════════════════════════════════
        // TEST 7 — SLVERR on out-of-range address
        // ════════════════════════════════════════════
        axi_write_resp(ADDR_OOB, 32'hDEAD_BEEF, wr_resp);
        check("T7a: write OOB returns SLVERR",   wr_resp == 2'b10);

        axi_read(ADDR_OOB, rd_data, rd_resp);
        check("T7b: read OOB returns SLVERR",    rd_resp  == 2'b10);
        check("T7c: read OOB rdata = DEAD_BEEF", rd_data  == 32'hDEAD_BEEF);

        // ════════════════════════════════════════════
        // BONUS — wstrb byte-lane test
        // write only byte 0 of DESC_PTR[0]
        // ════════════════════════════════════════════
        axi_write(ADDR_DP0, 32'hAAAA_0000, 4'hF); // full write first
        @(posedge aclk);
        axi_write(ADDR_DP0, 32'h0000_00BB, 4'h1); // byte0 only
        @(posedge aclk);
        check("BONUS: wstrb byte0 only write correct",
              desc_ptr_o[0] == 32'hAAAA_00BB);

        // ════════════════════════════════════════════
        // Summary
        // ════════════════════════════════════════════
        repeat(4) @(posedge aclk);
        $display("─────────────────────────────────────");
        $display("Results:  PASS=%0d  FAIL=%0d", pass_count, fail_count);
        $display("─────────────────────────────────────");
        if (fail_count == 0)
            $display("ALL TESTS PASSED");
        else
            $display("SOME TESTS FAILED — check above");

        $finish;
    end

    // ───────────────────────────────────────────────
    // Timeout watchdog — kills sim if it hangs
    // ───────────────────────────────────────────────
    initial begin
        #100000;
        $display("TIMEOUT — simulation hung");
        $finish;
    end

endmodule