
import dma_pkg::axi_lite_transaction;
import dma_pkg::desc_transaction;
import dma_pkg::data_transaction;
import dma_pkg::generator;
import dma_pkg::driver;


class enviroment;
    mailbox     gen2drv;
    generator   gen;
    driver      drv;
    virtual dma_interface dma_if;
    function new(virtual dma_interface dma_if);
        gen2drv = new();
        gen = new(gen2drv);
        drv = new(gen2drv, dma_if.lite_master, dma_if.axi_slave);
        this.dma_if = dma_if;
    endfunction
    task run();
        @(dma_if.reset_done); // Wait for reset to complete
        fork 
            gen.run();
            drv.run();
        join
    endtask

endclass