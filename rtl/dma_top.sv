

module dma_top #(
    parameter int N = 4,
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter DESC_WIDTH = 128,
    parameter LEN_WIDTH  = 24
)(
    // ==========================================
    // Clock and Reset
    // ==========================================
    input  logic                  aclk,
    input  logic                  rst_n,

    // ==========================================
    // AXI-4 Lite CPU-facing signals (Register Config)
    // ==========================================
    /*
    input  logic [31:0]           awaddr,
    input  logic                  awvalid,
    output logic                  awready,
    input  logic [31:0]           wdata,
    input  logic [3:0]            wstrb,
    input  logic                  wvalid,
    output logic                  wready,
    output logic [1:0]            bresp,
    output logic                  bvalid,
    input  logic                  bready,
    input  logic [31:0]           araddr,
    input  logic                  arvalid,
    output logic                  arready,
    output logic [31:0]           rdata,
    output logic [1:0]            rresp,
    output logic                  rvalid,
    input  logic                  rready,
    */
    dma_interface.lite_slave       dut_axi_lite_if,

    // ==========================================
    // CPU Direct Interface (Arbiter 2x1 Upper Left)
    // ==========================================
    /*
    input  logic                  cpu_read_req,
    input  logic [ADDR_WIDTH-1:0] cpu_read_addr,
    input  logic                  cpu_write_req,
    input  logic [ADDR_WIDTH-1:0] cpu_write_addr,
    input  logic [DATA_WIDTH-1:0] cpu_write_data,
    input  logic [2:0]            cpu_write_strb,
    output logic                  cpu_c_read_done,
    output logic                  cpu_c_write_done,
    output logic [DATA_WIDTH-1:0] cpu_read_data,
    output logic                  c_read_error_o,
    output logic                  c_write_error_o,
    //output logic [1:0]            cpu_read_resp,
    */
    dma_interface.cpu_dut          dut_cpu_if,

    /*****************************************
        AXI MASTER <-> AXI SLAVE (MEMORY)
    ******************************************/
        // READ Address Channel
        /*
    input logic                 ar_ready_i,
    output logic                ar_valid_o,
    output logic [ADDR_W-1:0]   ar_addr_o,
    output logic [7:0]          ar_len_o,
    output logic [2:0]          ar_size_o,
    output logic [1:0]          ar_burst_o,
        // WRITE Address Channel
    input  logic                aw_ready_i,
    output logic                aw_valid_o,
    output logic [ADDR_W-1:0]   aw_addr_o,
    output logic [7:0]          aw_len_o,
    output logic [2:0]          aw_size_o,
    output logic [1:0]          aw_burst_o,
            // READ Data Channel
    input logic                 r_valid_i,
    input logic [DATA_W-1:0]    r_data_i,
    input logic                 r_last_i,
    input logic [1:0]           r_resp_i,
    output logic                r_ready_o,
            // WRITE DATA CHANNEL
    output logic                w_valid_o,
    output logic [DATA_W-1:0]   w_data_o,
    input logic                 w_ready_i,
            // WRITE RESPONSE CHANNEL
    input logic                 b_valid_i,
    input logic [1:0]           b_resp_i,
    output logic                b_ready_o
    */
    dma_interface.axi_master          dut_axi_if,
    // DMA DONE AND ERROR INTERRUPTS
    output logic [N-1:0] done_intrpt_o,
    output logic [N-1:0] error_intrpt_o
);
    // ==========================================
    // Arbiter Interface With AXI MASTER (Arbiter 2x1 Right Side)
    // ==========================================
    logic                  rm_req;
    logic [ADDR_WIDTH-1:0] rm_addr;
    logic [ADDR_WIDTH-1:0] desc_addr_arb;
    logic                  desc_fetch_arb;
    logic                  wm_req;
    logic [ADDR_WIDTH-1:0] wm_addr;
    
    logic [LEN_WIDTH-1:0]  master_len;
    logic [DATA_WIDTH-1:0] wm_data;
    logic                  cpu_op; // New signal to indicate CPU operation
    //logic [3:0]            wm_strb,
    
    logic                  axi_read_done;
    logic                  axi_write_done;
    logic [DATA_WIDTH-1:0] axi_read_data;
    //logic [1:0]            axi_read_resp,
    logic [DESC_WIDTH-1:0] axi_desc_data;
    logic                  axi_data_valid;
    logic                  axi_read_error;
    logic                  axi_write_error;
    logic                  axi_master_idle;
    logic                  axi_wr_master_idle;

    // ==========================================
    // Internal Wires: Reg Top <-> FSMs
    // ==========================================
    logic [N-1:0]                 ch_en;
    logic [N-1:0]                 ch_abort;
    logic [31:0]                  desc_ptr [0:N-1];
    logic [1:0]                   response_status [0:N-1];
    logic [N-1:0]                 ch_done;
    logic [N-1:0]                 busy;
    logic [N-1:0]                 response_valid;
    logic [1:0]                   err_resp [0:N-1];
    logic [N-1:0]                 clear_en;

    // ==========================================
    // Internal Wires: FSMs <-> Internal Arbiter 1x1
    // (Using packed arrays for multi-channel support)
    // ==========================================
    logic [N-1:0]                 fsm_ch_req;
    logic [N-1:0]                 fsm_start_read;
    logic [N-1:0]                 fsm_write_start;
    logic [N-1:0][ADDR_WIDTH-1:0] fsm_src_address;
    logic [N-1:0][ADDR_WIDTH-1:0] fsm_dest_address;
    logic [N-1:0][ADDR_WIDTH-1:0] fsm_desc_address;
    logic [N-1:0][LEN_WIDTH-1:0]  fsm_len;
    logic [N-1:0]                 fsm_type_in;
    
    logic [N-1:0]                 fsm_grant;
    logic [127:0]                 fsm_desc_data_out;
    logic [N-1:0]                 fsm_desc_valid;
    logic [N-1:0]                 fsm_read_done;
    logic [N-1:0]                 fsm_write_done;
    logic [N-1:0]                 fsm_read_error;
    logic [N-1:0]                 fsm_write_error;

    // ==========================================
    // Internal Wires: Internal Arbiter 1x1 <-> Arbiter 2x1
    // ==========================================
    logic [ADDR_WIDTH-1:0]        int_src_addr;
    logic [ADDR_WIDTH-1:0]        int_dest_addr;
    logic [ADDR_WIDTH-1:0]        int_desc_addr;
    logic [LEN_WIDTH-1:0]         int_transfer_len;
    logic                         int_start_read;
    logic                         int_start_write;
    logic                         int_desc_fetch;
    
    logic                         int_read_done;
    logic                         int_write_done;
    logic                         int_read_error;
    logic                         int_write_error;
    logic [DESC_WIDTH-1:0]        int_desc_data;
    logic                         int_desc_valid;
    logic                         int_read_master_idle;
    logic                         int_write_master_idle;
    // debugging signal
    assign dut_axi_if.rd_master_idle_o = axi_master_idle; 
    assign dut_axi_if.wr_master_idle_o = axi_wr_master_idle;

    // ==========================================
    // Instantiation: DMA Register Config Top
    // ==========================================
    dma_reg_top #(
        .N(N)
    ) dma_reg_top_inst (
        .aclk           (aclk),
        .rst_n          (rst_n),
        .awaddr         (dut_axi_lite_if.awaddr),
        .awvalid        (dut_axi_lite_if.awvalid),
        .awready        (dut_axi_lite_if.awready),
        .wdata          (dut_axi_lite_if.wdata),
        .wstrb          (dut_axi_lite_if.wstrb),
        .wvalid         (dut_axi_lite_if.wvalid),
        .wready         (dut_axi_lite_if.wready),
        .bresp          (dut_axi_lite_if.bresp),
        .bvalid         (dut_axi_lite_if.bvalid),
        .bready         (dut_axi_lite_if.bready),
        .araddr         (dut_axi_lite_if.araddr),
        .arvalid        (dut_axi_lite_if.arvalid),
        .arready        (dut_axi_lite_if.arready),
        .rdata          (dut_axi_lite_if.rdata),
        .rresp          (dut_axi_lite_if.rresp),
        .rvalid         (dut_axi_lite_if.rvalid),
        .rready         (dut_axi_lite_if.rready),
        .ch_en_o        (ch_en),
        .ch_abort_o     (ch_abort),
        .desc_ptr_o     (desc_ptr),
        .error_i        (response_status),
        .done_i         (ch_done),
        .busy_i         (busy),
        .resp_valid_i   (response_valid),
        .err_resp_o     (err_resp),
        .irq_o          (done_intrpt_o),
        .err_irq_o      (error_intrpt_o),
        .clear_en_i     (clear_en)
    );

    // ==========================================
    // Instantiation: N x DMA Channel FSMs
    // ==========================================
    genvar i;
    generate
        for (i = 0; i < N; i++) begin : gen_dma_fsm 
            dma_fsm dma_fsm_inst (
                .clk             (aclk),
                .rst_n           (rst_n),
                
                // Reg Top Interface
                .ch_en           (ch_en[i]          ),
                .ch_abort        (ch_abort[i]       ),
                .desc_ptr        (desc_ptr[i]       ),
                .error_response  (err_resp[i]       ),
                .response_status (response_status[i]),
                .ch_done         (ch_done[i]        ),
                .busy            (busy[i]           ),
                .response_valid  (response_valid[i] ),
                .clear_en_o      (clear_en[i]       ),
                
                // Arbiter 1x1 Outputs (Requests from FSM)
                .ch_req          (fsm_ch_req[i]),
                .start_read      (fsm_start_read[i]),
                .start_write     (fsm_write_start[i]),
                .src_addr        (fsm_src_address[i]),
                .dest_addr       (fsm_dest_address[i]),
                .desc_addr       (fsm_desc_address[i]),
                .len             (fsm_len[i]),
                .desc_fetch      (fsm_type_in[i]),
                
                // Arbiter 1x1 Inputs (Responses to FSM)
                .grant           (fsm_grant[i]),
                .desc_data       (fsm_desc_data_out), // Broadcast to all
                .desc_valid      (fsm_desc_valid[i]),
                .read_done       (fsm_read_done[i]),
                .write_done      (fsm_write_done[i]),
                .read_error      (fsm_read_error[i]),
                .write_error     (fsm_write_error[i])
            );
        end
    endgenerate

    // ==========================================
    // Instantiation: Internal DMA Arbiter (1x1)
    // ==========================================
    internal_dma_arbiter_top #(
        .N(N),
        .ADDR_WIDTH(ADDR_WIDTH),
        .LEN_WIDTH(LEN_WIDTH)
    ) int_arbiter_inst (
        .clk             (aclk),
        .rst_n           (rst_n),

        // Interface 1: Connected to Channel FSMs
        .ch_req          (fsm_ch_req),
        .start_read      (fsm_start_read),
        .write_start     (fsm_write_start),
        .src_address     (fsm_src_address),
        .dest_address    (fsm_dest_address),
        .desc_address    (fsm_desc_address),
        .len             (fsm_len),
        .type_in         (fsm_type_in),
        
        .grant           (fsm_grant),
        .desc_data_out   (fsm_desc_data_out),
        .desc_valid      (fsm_desc_valid),
        .read_done       (fsm_read_done),
        .write_done      (fsm_write_done),
        .read_error      (fsm_read_error),
        .write_error     (fsm_write_error),

        // Interface 2: Connected to Arbiter 2x1
        .rd_master_idle  (int_read_master_idle),
        .wr_master_idle  (int_write_master_idle),
        .read_done_in    (int_read_done),
        .write_done_in   (int_write_done),
        .read_error_in   (int_read_error),
        .write_error_in  (int_write_error),
        .datavalid_in    (int_desc_valid),
        .desc_data_in    (int_desc_data),

        .src_address_o   (int_src_addr),
        .dest_address_o  (int_dest_addr),
        .desc_address_o  (int_desc_addr),
        .transfer_length_o(int_transfer_len),
        .start_read_i    (int_start_read),
        .start_write_i   (int_start_write),
        .desc_fetch_o    (int_desc_fetch)
    );

    // ==========================================
    // Instantiation: DMA Arbiter (2x1)
    // ==========================================
    arbiter_top #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .DESC_WIDTH(DESC_WIDTH),
        .LEN_WIDTH(LEN_WIDTH)
    ) ext_arbiter_inst (
        .clk                  (aclk),
        .rst_n                (rst_n),

        // CPU Interface (Upper Left) - Exposed to Top
        .read_req             (dut_cpu_if.cpu_read_req),
        .read_addr            (dut_cpu_if.cpu_read_addr),
        .write_req            (dut_cpu_if.cpu_write_req),
        .write_addr           (dut_cpu_if.cpu_write_addr),
        .write_data           (dut_cpu_if.cpu_write_data),
        .write_strb           (dut_cpu_if.cpu_write_strb),
        .c_read_done          (dut_cpu_if.cpu_c_read_done),
        .c_write_done         (dut_cpu_if.cpu_c_write_done),
        .c_read_error_o       (dut_cpu_if.c_read_error_o),
        .c_write_error_o      (dut_cpu_if.c_write_error_o),
        .read_data            (dut_cpu_if.cpu_read_data),
        //.read_resp            (cpu_read_resp),

        // DMA Interface (Lower Left) - Tied to Internal Arbiter 1x1
        .start_read_i         (int_start_read),
        .src_addr             (int_src_addr),
        .start_write_i        (int_start_write),
        .dest_addr            (int_dest_addr),
        .transfer_len         (int_transfer_len),
        .d_read_done          (int_read_done),
        .d_write_done         (int_write_done),
        .desc_data            (int_desc_data),
        .desc_valid           (int_desc_valid),
        .d_read_error_o          (int_read_error),
        .d_write_error_o       (int_write_error),
        .read_master_idle     (int_read_master_idle),
        .write_master_idle    (int_write_master_idle),
        .desc_fetch_i          (int_desc_fetch),
        .desc_addr_i           (int_desc_addr),

        // AXI Masters Interface (Right Side) - Exposed to Top
        .rm_req               (rm_req),
        .rm_addr              (rm_addr),
        .wm_req               (wm_req),
        .wm_addr              (wm_addr),
        .master_len           (master_len),
        .wm_data              (wm_data),
        .desc_addr_o          (desc_addr_arb),
        .desc_fetch_o         (desc_fetch_arb),
        .cpu_op_o             (cpu_op),
        //.wm_strb              (wm_strb),
        .axi_read_done        (axi_read_done),
        .axi_write_done       (axi_write_done),
        .axi_read_data        (axi_read_data),
        //.axi_read_resp        (axi_read_resp),
        .axi_desc_data        (axi_desc_data),
        .axi_data_valid       (axi_data_valid),
        .axi_read_error       (axi_read_error),
        .axi_write_error      (axi_write_error),
        .axi_master_idle      (axi_master_idle),
        .axi_wr_master_idle   (axi_wr_master_idle)
    );

    axi_master_top axi_master_top_inst (
        /******************************** 
            GLOBAL SIGNALS
        *********************************/
        .clk(aclk),
        .rst_n(rst_n),
        /******************************** 
            ARBITER <-> AXI MASTER
        *********************************/
        /********************************
            ARBITER -> AXI MASTER
        *********************************/
        .start_read_i           (rm_req),
        .src_addr_i             (rm_addr),
        .transfer_len_i         (master_len),
        .desc_fetch_i           (desc_fetch_arb),
        .desc_addr_i            (desc_addr_arb),
        .dest_addr_i            (wm_addr),
        .start_write_i          (wm_req),
        .c_data_i               (wm_data),
        .cpu_op_i                (cpu_op), 
        /********************************
            AXI MASTER -> ARBITER
        *********************************/
        .read_done_o            (axi_read_done),
        .rd_master_idle_o       (axi_master_idle),
        .read_error_o           (axi_read_error),
        .data_valid_o           (axi_data_valid),
        .desc_data_o            (axi_desc_data),
        .wr_master_idle_o       (axi_wr_master_idle),
        .wr_done_o              (axi_write_done),
        .wr_error_o             (axi_write_error),
        .c_data_o               (axi_read_data),
        /*****************************************
            AXI MASTER <-> AXI SLAVE (MEMORY)
        ******************************************/
            // READ Address Channel
        .ar_ready_i             (dut_axi_if.ar_ready_i),
        .ar_valid_o             (dut_axi_if.ar_valid_o),
        .ar_addr_o              (dut_axi_if.ar_addr_o),
        .ar_len_o               (dut_axi_if.ar_len_o),
        .ar_size_o              (dut_axi_if.ar_size_o),
        .ar_burst_o             (dut_axi_if.ar_burst_o),
            // READ Data Channel
        .r_valid_i              (dut_axi_if.r_valid_i),
        .r_data_i               (dut_axi_if.r_data_i),
        .r_last_i               (dut_axi_if.r_last_i),
        .r_resp_i               (dut_axi_if.r_resp_i),
        .r_ready_o              (dut_axi_if.r_ready_o),
            // WRITE Address Channel
        .aw_ready_i             (dut_axi_if.aw_ready_i),
        .aw_valid_o             (dut_axi_if.aw_valid_o),
        .aw_addr_o              (dut_axi_if.aw_addr_o),
        .aw_len_o               (dut_axi_if.aw_len_o),
        .aw_size_o              (dut_axi_if.aw_size_o),
        .aw_burst_o             (dut_axi_if.aw_burst_o),
            // WRITE DATA CHANNEL
        .w_valid_o              (dut_axi_if.w_valid_o),
        .w_data_o               (dut_axi_if.w_data_o),
        .w_ready_i              (dut_axi_if.w_ready_i),
            // WRITE RESPONSE CHANNEL
        .b_valid_i              (dut_axi_if.b_valid_i),
        .b_resp_i               (dut_axi_if.b_resp_i),
        .b_ready_o              (dut_axi_if.b_ready_o)

    );

endmodule