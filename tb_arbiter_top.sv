`timescale 1ns / 1ps

module tb_arbiter_top();

    // ==========================================
    // Parameters & Signals
    // ==========================================
    parameter ADDR_WIDTH = 32;
    parameter DATA_WIDTH = 32;
    parameter DESC_WIDTH = 128;
    parameter LEN_WIDTH  = 8;

    logic clk;
    logic rst_n;

    // CPU Inputs
    logic                  read_req;
    logic [ADDR_WIDTH-1:0] read_addr;
    logic                  write_req;
    logic [ADDR_WIDTH-1:0] write_addr;
    logic [DATA_WIDTH-1:0] write_data;
    logic [2:0]            write_strb;

    // CPU Outputs
    logic                  c_read_done;
    logic                  c_write_done;
    logic [DATA_WIDTH-1:0] out_read_data;
    logic [1:0]            out_read_resp;

    // DMA Inputs
    logic                  start_read_i;
    logic [ADDR_WIDTH-1:0] src_addr;
    logic                  start_write_i;
    logic [ADDR_WIDTH-1:0] dest_addr;
    logic [LEN_WIDTH-1:0]  transfer_len;

    // DMA Outputs
    logic                  d_read_done;
    logic                  d_write_done;
    logic [DESC_WIDTH-1:0] out_desc_data;
    logic                  out_desc_valid;
    logic                  out_read_error;
    logic                  out_write_error;
    logic                  out_read_master_idle;
    logic                  out_write_master_idle;

    // AXI Masters Inputs (Mocked Responses)
    logic                  axi_read_done;
    logic                  axi_write_done;
    logic [DATA_WIDTH-1:0] axi_read_data;
    logic [1:0]            axi_read_resp;
    logic [DESC_WIDTH-1:0] axi_desc_data;
    logic                  axi_data_valid;
    logic                  axi_read_error;
    logic                  axi_write_error;
    logic                  axi_master_idle;
    logic                  axi_wr_master_idle;

    // AXI Masters Outputs
    logic                  rm_req;
    logic [ADDR_WIDTH-1:0] rm_addr;
    logic                  wm_req;
    logic [ADDR_WIDTH-1:0] wm_addr;
    logic [LEN_WIDTH-1:0]  master_len;
    logic [DATA_WIDTH-1:0] wm_data;
    logic [2:0]            wm_strb;

    // ==========================================
    // DUT Instantiation
    // ==========================================
    arbiter_top #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .DESC_WIDTH(DESC_WIDTH),
        .LEN_WIDTH(LEN_WIDTH)
    ) dut (
        .clk(clk), .rst_n(rst_n),
        .read_req(read_req), .read_addr(read_addr),
        .write_req(write_req), .write_addr(write_addr),
        .write_data(write_data), .write_strb(write_strb),
        .c_read_done(c_read_done), .c_write_done(c_write_done),
        .read_data(out_read_data), .read_resp(out_read_resp),

        .start_read_i(start_read_i), .src_addr(src_addr),
        .start_write_i(start_write_i), .dest_addr(dest_addr),
        .transfer_len(transfer_len),
        .d_read_done(d_read_done), .d_write_done(d_write_done),
        .desc_data(out_desc_data), .desc_valid(out_desc_valid),
        .read_error(out_read_error), .write_error(out_write_error),
        .read_master_idle(out_read_master_idle), .write_master_idle(out_write_master_idle),

        .rm_req(rm_req), .rm_addr(rm_addr),
        .wm_req(wm_req), .wm_addr(wm_addr),
        .master_len(master_len), .wm_data(wm_data), .wm_strb(wm_strb),

        .axi_read_done(axi_read_done), .axi_write_done(axi_write_done),
        .axi_read_data(axi_read_data), .axi_read_resp(axi_read_resp),
        .axi_desc_data(axi_desc_data), .axi_data_valid(axi_data_valid),
        .axi_read_error(axi_read_error), .axi_write_error(axi_write_error),
        .axi_master_idle(axi_master_idle), .axi_wr_master_idle(axi_wr_master_idle)
    );

    // ==========================================
    // Clock Generation
    // ==========================================
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz
    end

    // ==========================================
    // Mock AXI Response Tasks (Using NEGEDGE)
    // ==========================================
    task mock_axi_read_response();
        @(negedge clk);
        axi_read_done = 1;
        @(negedge clk);
        axi_read_done = 0;
    endtask

    task mock_axi_write_response();
        @(negedge clk);
        axi_write_done = 1;
        @(negedge clk);
        axi_write_done = 0;
    endtask

    // ==========================================
    // Test Sequence
    // ==========================================
    initial begin
        // Initialize Signals Safely
        rst_n = 0;
        read_req = 0; read_addr = '0;
        write_req = 0; write_addr = '0; write_data = '0; write_strb = '0;
        start_read_i = 0; src_addr = '0;
        start_write_i = 0; dest_addr = '0; transfer_len = '0;
        
        axi_read_done = 0; axi_write_done = 0;
        axi_read_data = '0; axi_read_resp = '0; axi_desc_data = '0;
        axi_data_valid = 0; axi_read_error = 0; axi_write_error = 0;
        axi_master_idle = 1; axi_wr_master_idle = 1;

        $display("--- Applying Reset ---");
        @(negedge clk);
        @(negedge clk);
        rst_n = 1;
        @(negedge clk);

        // -----------------------------------------------------------
        // Test Case 1: CPU Read Only
        // -----------------------------------------------------------
        $display("--- Test Case 1: CPU Read ---");
        read_req = 1;
        read_addr = 32'hAAAA_BBBB;
        
        @(negedge clk); // Allow posedge to transition FSM
        if (rm_req && rm_addr == 32'hAAAA_BBBB && master_len == 0) 
            $display("PASS: CPU Read requested correctly.");
        else 
            $display("FAIL: CPU Read routing failed.");
        
        read_req = 0; // Drop request
        mock_axi_read_response();
        if (c_read_done && !d_read_done) $display("PASS: CPU Read Done routed correctly.");
        
        // Wait one cycle to ensure FSM returns to IDLE
        @(negedge clk);

        // -----------------------------------------------------------
        // Test Case 2: DMA Write Only
        // -----------------------------------------------------------
        $display("--- Test Case 2: DMA Write ---");
        start_write_i = 1;
        dest_addr = 32'hDDDD_EEEE;
        transfer_len = 8'h0F;
        
        @(negedge clk); 
        if (wm_req && wm_addr == 32'hDDDD_EEEE && master_len == 8'h0F) 
            $display("PASS: DMA Write requested correctly.");
        else 
            $display("FAIL: DMA Write routing failed.");
            
        start_write_i = 0;
        mock_axi_write_response();
        if (!c_write_done && d_write_done) $display("PASS: DMA Write Done routed correctly.");
        
        @(negedge clk);

        // -----------------------------------------------------------
        // Test Case 3: Priority Collision (Assert ALL simultaneously)
        // Expected Order: CPU Read -> CPU Write -> DMA Read -> DMA Write
        // -----------------------------------------------------------
        $display("--- Test Case 3: Absolute Priority Collision ---");
        
        read_req      = 1; read_addr  = 32'h1111_0000;
        write_req     = 1; write_addr = 32'h2222_0000; write_data = 32'hDEADBEEF; write_strb = 3'b111;
        start_read_i  = 1; src_addr   = 32'h3333_0000; transfer_len = 8'h04;
        start_write_i = 1; dest_addr  = 32'h4444_0000;

        // Step A: CPU Read should win first
        @(negedge clk);
        if (rm_req && rm_addr == 32'h1111_0000) $display("PASS: Priority 1 - CPU Read won.");
        else $display("FAIL: CPU Read did not win priority.");
        read_req = 0; 
        mock_axi_read_response();
        
        // Step B: CPU Write should win next
        @(negedge clk); 
        if (wm_req && wm_addr == 32'h2222_0000 && wm_data == 32'hDEADBEEF) $display("PASS: Priority 2 - CPU Write won.");
        else $display("FAIL: CPU Write did not win priority.");
        write_req = 0;
        mock_axi_write_response();
        
        // Step C: DMA Read should win next
        @(negedge clk); 
        if (rm_req && rm_addr == 32'h3333_0000 && master_len == 8'h04) $display("PASS: Priority 3 - DMA Read won.");
        else $display("FAIL: DMA Read did not win priority.");
        start_read_i = 0;
        mock_axi_read_response();
        
        // Step D: DMA Write should win last
        @(negedge clk);
        if (wm_req && wm_addr == 32'h4444_0000 && master_len == 8'h04) $display("PASS: Priority 4 - DMA Write won.");
        else $display("FAIL: DMA Write did not win priority.");
        start_write_i = 0;
        mock_axi_write_response();

        // -----------------------------------------------------------
        // Test Case 4: Pass-Through Signal Verification
        // -----------------------------------------------------------
        $display("--- Test Case 4: Data Pass-Through ---");
        axi_read_data = 32'h12345678;
        axi_desc_data = 128'hFFFF_EEEE_DDDD_CCCC_BBBB_AAAA_9999_8888;
        axi_data_valid = 1;
        axi_read_error = 1;
        #1;
        if (out_read_data == 32'h12345678 && out_desc_data == 128'hFFFF_EEEE_DDDD_CCCC_BBBB_AAAA_9999_8888)
            $display("PASS: Response data paths mapped correctly.");

        #50;
        $display("--- Simulation Complete ---");
        $finish;
    end

endmodule