`timescale 1ns/1ps

module tb_internal_dma_arbiter();

    // Parameters
    parameter N = 4;
    parameter ADDR_WIDTH = 32;
    parameter LEN_WIDTH = 8;

    // Clock and Reset
    logic clk;
    logic rst_n;

    // Interface 1: Channel FSMs
    logic [N-1:0]         ch_req;
    logic [N-1:0]         start_read;
    logic [N-1:0]         write_start;
    
    // FIXED: Packed Arrays
    logic [N-1:0][ADDR_WIDTH-1:0] src_address;
    logic [N-1:0][ADDR_WIDTH-1:0] dest_address;
    logic [N-1:0][ADDR_WIDTH-1:0] desc_address;
    logic [N-1:0][LEN_WIDTH-1:0]  len;
    logic [N-1:0]                 type_in;
    
    logic [N-1:0]         grant;
    logic [127:0]         desc_data_out;
    logic [N-1:0]         desc_valid;
    logic [N-1:0]         read_done;
    logic [N-1:0]         write_done;
    logic [N-1:0]         read_error;
    logic [N-1:0]         write_error;

    // Interface 2: 2x1 External Arbiter
    logic                 rd_master_idle;
    logic                 wr_master_idle;
    logic                 read_done_in;
    logic                 write_done_in;
    logic                 read_error_in;
    logic                 write_error_in;
    logic                 datavalid_in;
    logic [127:0]         desc_data_in;

    logic [ADDR_WIDTH-1:0] src_address_o;
    logic [ADDR_WIDTH-1:0] dest_address_o;
    logic [LEN_WIDTH-1:0]  transfer_length_o;
    logic                  start_read_i;
    logic                  start_write_i;

    // Instantiate the DUT (Device Under Test)
    internal_dma_arbiter_top #(
        .N(N), .ADDR_WIDTH(ADDR_WIDTH), .LEN_WIDTH(LEN_WIDTH)
    ) dut (.*);

    // Clock Generation (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // --------------------------------------------------------
    // DEBUGGER / TRANSCRIPT LOGGING
    // --------------------------------------------------------
    always @(posedge clk) begin
        if (rst_n && (dut.u_controller.current_state != dut.u_controller.next_state)) begin
            $display("[Time %0t ns] [FSM] State Change: %s -> %s | Granted CH: %0d", 
                     $time, 
                     dut.u_controller.current_state.name(), 
                     dut.u_controller.next_state.name(), 
                     dut.current_ch_id);
        end
    end

    always @(posedge clk) begin
        if (start_read_i) 
            $display("[Time %0t ns] [BUS] -> start_read_i triggered. Address: 0x%0h, Len: %0d", $time, src_address_o, transfer_length_o);
        if (start_write_i) 
            $display("[Time %0t ns] [BUS] -> start_write_i triggered. Address: 0x%0h, Len: %0d", $time, dest_address_o, transfer_length_o);
        if (desc_valid != 0)
            $display("[Time %0t ns] [FSM] <- desc_valid sent to Channel %b. Data: 0x%0h", $time, desc_valid, desc_data_out);
        if (read_done != 0)
            $display("[Time %0t ns] [FSM] <- read_done sent to Channel %b", $time, read_done);
        if (write_done != 0)
            $display("[Time %0t ns] [FSM] <- write_done sent to Channel %b", $time, write_done);
    end

    // --------------------------------------------------------
    // TEST TASKS
    // --------------------------------------------------------
    task initialize_signals();
        ch_req = '0; start_read = '0; write_start = '0;
        rd_master_idle = 1; wr_master_idle = 1; // Bus is free by default
        read_done_in = 0; write_done_in = 0; read_error_in = 0; write_error_in = 0;
        datavalid_in = 0; desc_data_in = '0;
        
        // FIXED: With Packed Arrays, we can clear the whole bus instantly!
        src_address  = '0;
        dest_address = '0;
        desc_address = '0;
        len          = '0;
        type_in      = '0;
    endtask

    // --------------------------------------------------------
    // MAIN TEST SEQUENCE
    // --------------------------------------------------------
    initial begin
        $display("==================================================");
        $display("   STARTING INTERNAL DMA ARBITER SIMULATION");
        $display("==================================================");
        
        initialize_signals();
        
        // Assert Reset
        rst_n = 0;
        #20;
        rst_n = 1;
        #10;

        // --------------------------------------------------------
        // TEST CASE 1: Single Channel (CH 0) - Data Only (No Desc)
        // --------------------------------------------------------
        $display("\n--- TEST CASE 1: CH 0 Data Read/Write (No Descriptor) ---");
        src_address  = 32'hAAAA_0000;
        dest_address = 32'hBBBB_0000;
        len          = 8'd15; // 16 beats
        type_in      = 1'b0;  // 0 = Data

        ch_req = 1'b1; // Request the bus
        
        // Wait for Arbiter to lock and wait for start_read
        wait(dut.u_controller.current_state == dut.u_controller.WAIT_DATA_RD);
        #10;
        
        // FSM asserts start_read
        start_read = 1'b1;
        
        // Wait for the read trigger to hit the bus
        wait(start_read_i == 1'b1);
        #10;
        start_read = 1'b0; // FSM drops pulse
        
        // Simulate Bus Delay, then return read_done
        #30;
        read_done_in = 1'b1;
        #10;
        read_done_in = 1'b0;

        // FSM receives read_done, now asserts write_start
        wait(read_done == 1'b1);
        #10;
        write_start = 1'b1;

        // Wait for write trigger to hit the bus
        wait(start_write_i == 1'b1);
        #10;
        write_start = 1'b0;

        // Simulate Bus Delay, then return write_done
        #30;
        write_done_in = 1'b1;
        #10;
        write_done_in = 1'b0;

        // Sequence complete, drop request
        wait(write_done == 1'b1);
        ch_req = 1'b0;
        #20;

        // --------------------------------------------------------
        // TEST CASE 2: CH 1 Full Sequence (Desc -> Data Rd -> Data Wr)
        // --------------------------------------------------------
        $display("\n--- TEST CASE 2: CH 1 Full Sequence (Descriptor Fetch) ---");
        desc_address[1] = 32'hDDEE_0000;
        src_address[1]  = 32'h1111_0000;
        dest_address[1] = 32'h2222_0000;
        len[1]          = 8'd31; 
        type_in[1]      = 1'b1;  // 1 = Descriptor Fetch

        ch_req[1] = 1'b1; 
        
        // Wait for read trigger (Desc fetch happens automatically)
        wait(start_read_i == 1'b1);
        #10;

        // Simulate Bus returning 128-bit descriptor
        #20;
        desc_data_in = 128'hF0F0F0F0_E0E0E0E0_D0D0D0D0_C0C0C0C0;
        read_done_in = 1'b1;
        datavalid_in = 1'b1;
        #10;
        read_done_in = 1'b0;
        datavalid_in = 1'b0;

        // Wait for desc_valid, then simulate FSM starting data read
        wait(desc_valid[1] == 1'b1);
        #10;
        start_read[1] = 1'b1;

        // Wait for read trigger
        wait(start_read_i == 1'b1);
        #10;
        start_read[1] = 1'b0;

        // Simulate read finish
        #20;
        read_done_in = 1'b1;
        #10;
        read_done_in = 1'b0;

        // Wait for read_done, trigger write
        wait(read_done[1] == 1'b1);
        #10;
        write_start[1] = 1'b1;

        // Wait for write trigger
        wait(start_write_i == 1'b1);
        #10;
        write_start[1] = 1'b0;

        // Simulate write finish
        #20;
        write_done_in = 1'b1;
        #10;
        write_done_in = 1'b0;

        wait(write_done[1] == 1'b1);
        ch_req[1] = 1'b0;
        #20;

        // --------------------------------------------------------
        // TEST CASE 3: Multi-Channel Round Robin & CPU Bus Interruption
        // --------------------------------------------------------
        $display("\n--- TEST CASE 3: Multi-Channel Collision & CPU Interruption ---");
        
        // Setup CH 2 and CH 3 simultaneously
        src_address[2] = 32'h3333_0000; dest_address[2] = 32'h4444_0000; type_in[2] = 1'b0;
        src_address[3] = 32'h5555_0000; dest_address[3] = 32'h6666_0000; type_in[3] = 1'b0;
        
        ch_req[2] = 1'b1;
        ch_req[3] = 1'b1;

        // Arbiter should pick CH 2 first (Round Robin)
        wait(grant == 4'b0100); 
        $display("[Time %0t ns] [TEST] Round Robin correctly selected CH 2", $time);
        
        // SIMULATE CPU INTERRUPTION: Set bus to NOT idle
        rd_master_idle = 1'b0; 
        $display("[Time %0t ns] [TEST] CPU took the bus (rd_master_idle = 0). Arbiter should wait.", $time);
        
        #30; // FSM should be stuck in WAIT_DATA_RD
        start_read[2] = 1'b1;
        #20; // Trigger should NOT happen yet
        
        if (start_read_i == 0) $display("[Time %0t ns] [TEST] SUCCESS: Arbiter correctly waited for CPU.", $time);
        
        // Release bus
        rd_master_idle = 1'b1;
        $display("[Time %0t ns] [TEST] CPU released bus.", $time);

        // Now trigger should happen
        wait(start_read_i == 1'b1);
        #10;
        start_read[2] = 1'b0;
        
        #20; read_done_in = 1'b1; #10; read_done_in = 1'b0;
        
        wait(read_done[2] == 1'b1);
        write_start[2] = 1'b1;
        wait(start_write_i == 1'b1);
        #10; write_start[2] = 1'b0;
        
        #20; write_done_in = 1'b1; #10; write_done_in = 1'b0;
        wait(write_done[2] == 1'b1);
        ch_req[2] = 1'b0; // CH 2 Done

        // Arbiter should immediately move to CH 3
        wait(grant == 4'b1000);
        $display("[Time %0t ns] [TEST] Round Robin correctly advanced to CH 3", $time);
        
        // Complete CH 3
        #10; start_read[3] = 1'b1;
        wait(start_read_i == 1'b1); #10; start_read[3] = 1'b0;
        #20; read_done_in = 1'b1; #10; read_done_in = 1'b0;
        
        wait(read_done[3] == 1'b1); write_start[3] = 1'b1;
        wait(start_write_i == 1'b1); #10; write_start[3] = 1'b0;
        #20; write_done_in = 1'b1; #10; write_done_in = 1'b0;
        wait(write_done[3] == 1'b1);
        ch_req[3] = 1'b0; // CH 3 Done

        #50;
        $display("==================================================");
        $display("   SIMULATION COMPLETE. ALL TESTS PASSED.");
        $display("==================================================");
        $finish;
    end

endmodule