
// =============================================================================
// File    : dma_interface.sv
// Purpose : Single interface for DMA top-level testbench
//          
//
//           6 modports:
//             AXI4 Full  -> axi_master (TB/driver side)   axi_slave  (DUT side)
//             AXI4 Lite  -> lite_master (TB/driver side)  lite_slave (DUT side)
//             CPU Direct -> cpu_driver  (TB/driver side)  cpu_dut    (DUT side)
// =============================================================================

interface dma_interface #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter LEN_WIDTH  = 24,
    parameter DESC_WIDTH = 128
)(
    input logic aclk,
    input logic rst_n
);

    // =========================================================================
    // AXI4-Lite Signals  (CPU-facing register config)
    // =========================================================================

    // Write Address Channel
    logic [31:0]           awaddr;
    logic                  awvalid;
    logic                  awready;

    // Write Data Channel
    logic [31:0]           wdata;
    logic [3:0]            wstrb;
    logic                  wvalid;
    logic                  wready;

    // Write Response Channel
    logic [1:0]            bresp;
    logic                  bvalid;
    logic                  bready;

    // Read Address Channel
    logic [31:0]           araddr;
    logic                  arvalid;
    logic                  arready;

    // Read Data Channel
    logic [31:0]           rdata;
    logic [1:0]            rresp;
    logic                  rvalid;
    logic                  rready;

    // =========================================================================
    // CPU Direct Interface Signals
    // =========================================================================

    logic                  cpu_read_req;
    logic [ADDR_WIDTH-1:0] cpu_read_addr;
    logic                  cpu_write_req;
    logic [ADDR_WIDTH-1:0] cpu_write_addr;
    logic [DATA_WIDTH-1:0] cpu_write_data;
    logic [2:0]            cpu_write_strb;
    logic                  cpu_c_read_done;
    logic                  cpu_c_write_done;
    logic [DATA_WIDTH-1:0] cpu_read_data;
    logic                  c_read_error_o;
    logic                  c_write_error_o;

    // =========================================================================
    // AXI4 Full Signals  (AXI Master <-> AXI Slave / Memory)
    // =========================================================================

    // Read Address Channel
    logic                  ar_ready_i;
    logic                  ar_valid_o;
    logic [ADDR_WIDTH-1:0] ar_addr_o;
    logic [7:0]            ar_len_o;
    logic [2:0]            ar_size_o;
    logic [1:0]            ar_burst_o;

    // Write Address Channel
    logic                  aw_ready_i;
    logic                  aw_valid_o;
    logic [ADDR_WIDTH-1:0] aw_addr_o;
    logic [7:0]            aw_len_o;
    logic [2:0]            aw_size_o;
    logic [1:0]            aw_burst_o;

    // Read Data Channel
    logic                  r_valid_i;
    logic [DATA_WIDTH-1:0] r_data_i;
    logic                  r_last_i;
    logic [1:0]            r_resp_i;
    logic                  r_ready_o;

    // Write Data Channel
    logic                  w_valid_o;
    logic [DATA_WIDTH-1:0] w_data_o;
    logic                  w_ready_i;

    // Write Response Channel
    logic                  b_valid_i;
    logic [1:0]            b_resp_i;
    logic                  b_ready_o;
    //======================================
    event reset_done;

    // =========================================================================
    // Modport 1 : axi_master  — TB / driver side for AXI4 Full
    //
    //   TB pretends to be the memory slave:
    //     DUT outputs (_o) -> TB sees as input
    //     DUT inputs  (_i) -> TB drives as output
    // =========================================================================
    modport axi_slave (         // TB SIDE
        input  aclk,
        input  rst_n,

        // Read Address Channel
        input  ar_valid_o,          // DUT is requesting a read
        input  ar_addr_o,
        input  ar_len_o,
        input  ar_size_o,
        input  ar_burst_o,
        output ar_ready_i,          // TB grants the read address

        // Write Address Channel
        input  aw_valid_o,          // DUT is requesting a write
        input  aw_addr_o,
        input  aw_len_o,
        input  aw_size_o,
        input  aw_burst_o,
        output aw_ready_i,          // TB grants the write address

        // Read Data Channel
        output r_valid_i,           // TB drives read data back
        output r_data_i,
        output r_last_i,
        output r_resp_i,
        input  r_ready_o,           // DUT signals it consumed data

        // Write Data Channel
        input  w_valid_o,           // DUT sending write data
        input  w_data_o,
        output w_ready_i,           // TB ready to accept write data

        // Write Response Channel
        output b_valid_i,           // TB sends write response
        output b_resp_i,
        input  b_ready_o            // DUT consumed the response
    );

    // =========================================================================
    // Modport 2 : axi_slave  — DUT side for AXI4 Full
    //   Exact mirror of axi_master
    // =========================================================================
    modport axi_master (
        input  aclk,
        input  rst_n,

        // Read Address Channel
        output ar_valid_o,
        output ar_addr_o,
        output ar_len_o,
        output ar_size_o,
        output ar_burst_o,
        input  ar_ready_i,

        // Write Address Channel
        output aw_valid_o,
        output aw_addr_o,
        output aw_len_o,
        output aw_size_o,
        output aw_burst_o,
        input  aw_ready_i,

        // Read Data Channel
        input  r_valid_i,
        input  r_data_i,
        input  r_last_i,
        input  r_resp_i,
        output r_ready_o,

        // Write Data Channel
        output w_valid_o,
        output w_data_o,
        input  w_ready_i,

        // Write Response Channel
        input  b_valid_i,
        input  b_resp_i,
        output b_ready_o
    );

    // =========================================================================
    // Modport 3 : lite_master  — TB / driver side for AXI4-Lite
    //   TB acts as the CPU master: initiates register reads and writes
    //   DUT outputs -> TB sees as input
    //   DUT inputs  -> TB drives as output
    // =========================================================================
    modport lite_master (
        input  aclk,
        input  rst_n,

        // Write Address Channel
        output awaddr,
        output awvalid,
        input  awready,             // DUT acknowledges write address

        // Write Data Channel
        output wdata,
        output wstrb,
        output wvalid,
        input  wready,              // DUT ready to accept write data

        // Write Response Channel
        input  bresp,
        input  bvalid,              // DUT sends write response
        output bready,

        // Read Address Channel
        output araddr,
        output arvalid,
        input  arready,             // DUT acknowledges read address

        // Read Data Channel
        input  rdata,
        input  rresp,
        input  rvalid,              // DUT drives read data
        output rready
    );

    // =========================================================================
    // Modport 4 : lite_slave  — DUT side for AXI4-Lite
    //   Exact mirror of lite_master
    // =========================================================================
    modport lite_slave (
        input  aclk,
        input  rst_n,

        // Write Address Channel
        input  awaddr,
        input  awvalid,
        output awready,

        // Write Data Channel
        input  wdata,
        input  wstrb,
        input  wvalid,
        output wready,

        // Write Response Channel
        output bresp,
        output bvalid,
        input  bready,

        // Read Address Channel
        input  araddr,
        input  arvalid,
        output arready,

        // Read Data Channel
        output rdata,
        output rresp,
        output rvalid,
        input  rready
    );

    // =========================================================================
    // Modport 5 : cpu_driver  — TB / driver side for CPU Direct Interface
    //   TB mimics CPU: drives requests, observes DUT responses
    //   DUT outputs (_done, _o) -> TB sees as input
    //   DUT inputs              -> TB drives as output
    // =========================================================================
    modport cpu_driver (
        input  aclk,
        input  rst_n,

        // TB drives requests into DUT
        output cpu_read_req,
        output cpu_read_addr,
        output cpu_write_req,
        output cpu_write_addr,
        output cpu_write_data,
        output cpu_write_strb,

        // TB observes DUT responses
        input  cpu_c_read_done,
        input  cpu_c_write_done,
        input  cpu_read_data,
        input  c_read_error_o,
        input  c_write_error_o
    );

    // =========================================================================
    // Modport 6 : cpu_dut  — DUT side for CPU Direct Interface
    //   Exact mirror of cpu_driver
    // =========================================================================
    modport cpu_dut (
        input  aclk,
        input  rst_n,

        // DUT receives CPU requests
        input  cpu_read_req,
        input  cpu_read_addr,
        input  cpu_write_req,
        input  cpu_write_addr,
        input  cpu_write_data,
        input  cpu_write_strb,

        // DUT drives responses back to CPU
        output cpu_c_read_done,
        output cpu_c_write_done,
        output cpu_read_data,
        output c_read_error_o,
        output c_write_error_o
    );

endinterface 