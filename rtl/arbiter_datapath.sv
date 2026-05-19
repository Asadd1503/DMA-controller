`timescale 1ns / 1ps

module arbiter_datapath #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter DESC_WIDTH = 128,
    parameter LEN_WIDTH  = 8
)(
    // --- Inputs from CPU ---
    input  logic [ADDR_WIDTH-1:0] read_addr,
    input  logic [ADDR_WIDTH-1:0] write_addr,
    input  logic [DATA_WIDTH-1:0] write_data,
    input  logic [2:0]            write_strb,

    // --- Inputs from DMA ---
    input  logic [ADDR_WIDTH-1:0] src_addr,
    input  logic [ADDR_WIDTH-1:0] dest_addr,
    input  logic [LEN_WIDTH-1:0]  transfer_len,

    // --- Inputs from AXI Masters ---
    input  logic                  axi_read_done,
    input  logic                  axi_write_done,
    input  logic [DATA_WIDTH-1:0] axi_read_data,
    input  logic [1:0]            axi_read_resp,
    input  logic [DESC_WIDTH-1:0] axi_desc_data,
    input  logic                  axi_data_valid,
    input  logic                  axi_read_error,
    input  logic                  axi_write_error,
    input  logic                  axi_master_idle,
    input  logic                  axi_wr_master_idle,

    // --- Control Inputs from FSM ---
    input  logic                  sel_cpu_r,
    input  logic                  sel_cpu_w,
    input  logic                  sel_dma_r,
    input  logic                  sel_dma_w,

    // --- Outputs to AXI Masters ---
    output logic [ADDR_WIDTH-1:0] rm_addr,
    output logic [ADDR_WIDTH-1:0] wm_addr,
    output logic [LEN_WIDTH-1:0]  master_len,
    output logic [DATA_WIDTH-1:0] wm_data,
    output logic [2:0]            wm_strb,

    // --- Outputs to CPU ---
    output logic                  c_read_done,
    output logic                  c_write_done,
    output logic [DATA_WIDTH-1:0] out_read_data,
    output logic [1:0]            out_read_resp,

    // --- Outputs to DMA ---
    output logic                  d_read_done,
    output logic                  d_write_done,
    output logic [DESC_WIDTH-1:0] out_desc_data,
    output logic                  out_desc_valid,
    output logic                  out_read_error,
    output logic                  out_write_error,
    output logic                  out_read_master_idle,
    output logic                  out_write_master_idle
);

    // ==========================================
    // Block 1 & 2: Address Multiplexers
    // ==========================================
    always_comb begin
        // Read Address MUX
        if (sel_cpu_r)      rm_addr = read_addr;
        else if (sel_dma_r) rm_addr = src_addr;
        else                rm_addr = '0; 

        // Write Address MUX
        if (sel_cpu_w)      wm_addr = write_addr;
        else if (sel_dma_w) wm_addr = dest_addr;
        else                wm_addr = '0;
    end

    // ==========================================
    // Block 3: Master Length Multiplexer
    // ==========================================
    always_comb begin
        if (sel_dma_r || sel_dma_w) master_len = transfer_len;
        else                        master_len = '0; // CPU defaults to 0 (single beat)
    end

    // ==========================================
    // Block 4: CPU Direct Data Pass-Through
    // ==========================================
    assign wm_data = write_data;
    assign wm_strb = write_strb;

    // ==========================================
    // Block 6: DONE Router (DeMUX)
    // ==========================================
    assign c_read_done  = axi_read_done  & sel_cpu_r;
    assign d_read_done  = axi_read_done  & sel_dma_r;
    
    assign c_write_done = axi_write_done & sel_cpu_w;
    assign d_write_done = axi_write_done & sel_dma_w;

    // ==========================================
    // Block 5: Response Router (Wire Mapping)
    // ==========================================
    // To CPU
    assign out_read_data         = axi_read_data;
    assign out_read_resp         = axi_read_resp;
    
    // To DMA
    assign out_desc_data         = axi_desc_data;
    assign out_desc_valid        = axi_data_valid;
    assign out_read_error        = axi_read_error;
    assign out_write_error       = axi_write_error;
    assign out_read_master_idle  = axi_master_idle;
    assign out_write_master_idle = axi_wr_master_idle;

endmodule