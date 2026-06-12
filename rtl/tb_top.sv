
module tb_top;

    logic clk;
    logic rst_n;
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    dma_interface dma_if(.aclk(clk), .rst_n(rst_n));
    dma_top dma_dut (
        .aclk               (clk              ),
        .rst_n              (rst_n            ),
        .dut_axi_lite_if    (dma_if.lite_slave),
        .dut_axi_if         (dma_if.axi_master),
        .dut_cpu_if         (dma_if.cpu_dut   )
    );
    dma_tb dma_test(dma_if);
    initial begin
        rst_n = 0;
        @(posedge clk);
        rst_n = 1;
        @(posedge clk);
        -> dma_if.reset_done; // Trigger event to start env
    end
endmodule