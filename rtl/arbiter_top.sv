`timescale 1ns / 1ps

module arbiter_top #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter DESC_WIDTH = 128,
    parameter LEN_WIDTH  = 8
)(
    input logic clk,
    input logic rst_n,

    // ==========================================
    // CPU Interface (Upper Left)
    // ==========================================
    input  logic                  read_req,
    input  logic [ADDR_WIDTH-1:0] read_addr,
    input  logic                  write_req,
    input  logic [ADDR_WIDTH-1:0] write_addr,
    input  logic [DATA_WIDTH-1:0] write_data,
    input  logic [2:0]            write_strb,
    
    output logic                  c_read_done,
    output logic                  c_write_done,
    output logic [DATA_WIDTH-1:0] read_data,
    output logic [1:0]            read_resp,

    // ==========================================
    // DMA Interface (Lower Left)
    // ==========================================
    input  logic                  start_read_i,
    input  logic [ADDR_WIDTH-1:0] src_addr,
    input  logic                  start_write_i,
    input  logic [ADDR_WIDTH-1:0] dest_addr,
    input  logic [LEN_WIDTH-1:0]  transfer_len,

    output logic                  d_read_done,
    output logic                  d_write_done,
    output logic [DESC_WIDTH-1:0] desc_data,
    output logic                  desc_valid,
    output logic                  read_error,
    output logic                  write_error,
    output logic                  read_master_idle,
    output logic                  write_master_idle,

    // ==========================================
    // AXI Masters Interface (Right Side)
    // ==========================================
    // To AXI Masters
    output logic                  rm_req,
    output logic [ADDR_WIDTH-1:0] rm_addr,
    output logic                  wm_req,
    output logic [ADDR_WIDTH-1:0] wm_addr,
    output logic [LEN_WIDTH-1:0]  master_len,
    output logic [DATA_WIDTH-1:0] wm_data,
    output logic [2:0]            wm_strb,

    // From AXI Masters
    input  logic                  axi_read_done,
    input  logic                  axi_write_done,
    input  logic [DATA_WIDTH-1:0] axi_read_data,
    input  logic [1:0]            axi_read_resp,
    input  logic [DESC_WIDTH-1:0] axi_desc_data,
    input  logic                  axi_data_valid,
    input  logic                  axi_read_error,
    input  logic                  axi_write_error,
    input  logic                  axi_master_idle,
    input  logic                  axi_wr_master_idle
);

    // Internal wires connecting FSM and Datapath
    logic sel_cpu_r;
    logic sel_cpu_w;
    logic sel_dma_r;
    logic sel_dma_w;
    
    // Internal wires from DONE router back to FSM
    logic int_c_read_done;
    logic int_c_write_done;
    logic int_d_read_done;
    logic int_d_write_done;

    // Output assignments for the done signals
    assign c_read_done  = int_c_read_done;
    assign c_write_done = int_c_write_done;
    assign d_read_done  = int_d_read_done;
    assign d_write_done = int_d_write_done;

    // ==========================================
    // FSM Controller Instantiation
    // ==========================================
    arbiter_fsm u_arbiter_fsm (
        .clk            (clk),
        .rst_n          (rst_n),
        .read_req       (read_req),
        .write_req      (write_req),
        .start_read_i   (start_read_i),
        .start_write_i  (start_write_i),
        
        .c_read_done    (int_c_read_done),
        .c_write_done   (int_c_write_done),
        .d_read_done    (int_d_read_done),
        .d_write_done   (int_d_write_done),
        
        .rm_req         (rm_req),
        .wm_req         (wm_req),
        .sel_cpu_r      (sel_cpu_r),
        .sel_cpu_w      (sel_cpu_w),
        .sel_dma_r      (sel_dma_r),
        .sel_dma_w      (sel_dma_w)
    );

    // ==========================================
    // Datapath Instantiation
    // ==========================================
    arbiter_datapath #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .DESC_WIDTH(DESC_WIDTH),
        .LEN_WIDTH(LEN_WIDTH)
    ) u_arbiter_datapath (
        // CPU Inputs
        .read_addr             (read_addr),
        .write_addr            (write_addr),
        .write_data            (write_data),
        .write_strb            (write_strb),
        
        // DMA Inputs
        .src_addr              (src_addr),
        .dest_addr             (dest_addr),
        .transfer_len          (transfer_len),
        
        // AXI Inputs
        .axi_read_done         (axi_read_done),
        .axi_write_done        (axi_write_done),
        .axi_read_data         (axi_read_data),
        .axi_read_resp         (axi_read_resp),
        .axi_desc_data         (axi_desc_data),
        .axi_data_valid        (axi_data_valid),
        .axi_read_error        (axi_read_error),
        .axi_write_error       (axi_write_error),
        .axi_master_idle       (axi_master_idle),
        .axi_wr_master_idle    (axi_wr_master_idle),
        
        // FSM Selects
        .sel_cpu_r             (sel_cpu_r),
        .sel_cpu_w             (sel_cpu_w),
        .sel_dma_r             (sel_dma_r),
        .sel_dma_w             (sel_dma_w),
        
        // AXI Outputs
        .rm_addr               (rm_addr),
        .wm_addr               (wm_addr),
        .master_len            (master_len),
        .wm_data               (wm_data),
        .wm_strb               (wm_strb),
        
        // CPU Outputs
        .c_read_done           (int_c_read_done),
        .c_write_done          (int_c_write_done),
        .out_read_data         (read_data),
        .out_read_resp         (read_resp),
        
        // DMA Outputs
        .d_read_done           (int_d_read_done),
        .d_write_done          (int_d_write_done),
        .out_desc_data         (desc_data),
        .out_desc_valid        (desc_valid),
        .out_read_error        (read_error),
        .out_write_error       (write_error),
        .out_read_master_idle  (read_master_idle),
        .out_write_master_idle (write_master_idle)
    );

endmodule