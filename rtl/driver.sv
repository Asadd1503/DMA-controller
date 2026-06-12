
import dma_pkg::axi_lite_transaction;
import dma_pkg::desc_transaction;
import dma_pkg::data_transaction;
class driver;
    virtual dma_interface.lite_master drv_axi_lite_if; 
    virtual dma_interface.axi_slave   drv_axi_slave_if;
    mailbox gen2drv;
    logic [31:0] data_from_memory [];

    function new(mailbox gen2drv, virtual dma_interface.lite_master drv_axi_lite_if, virtual dma_interface.axi_slave drv_axi_slave_if);
        this.gen2drv = gen2drv;
        this.drv_axi_lite_if = drv_axi_lite_if;
        this.drv_axi_slave_if = drv_axi_slave_if;
    endfunction

    task run();
        axi_lite_transaction lite_trans;
        desc_transaction     desc_trans;
        data_transaction     data_trans;
        gen2drv.get(lite_trans);
        lite_trans.display("DRIVER");
        write_axi_lite(lite_trans.addr, lite_trans.wdata, lite_trans.wstrb, lite_trans.bresp);
        gen2drv.get(lite_trans);
        lite_trans.display("DRIVER");
        write_axi_lite(lite_trans.addr, lite_trans.wdata, lite_trans.wstrb, lite_trans.bresp);
        gen2drv.get(desc_trans);
        desc_trans.display("DRIVER");
        data_from_memory = new[4];
        data_from_memory[0] = desc_trans.src_addr;
        data_from_memory[1] = desc_trans.dest_addr;
        data_from_memory[2] = desc_trans.len_and_flag;
        data_from_memory[3] = desc_trans.nxt_desc;
        // DESCRIPTOR RAED
        axi_master_read(data_from_memory.size());
        // DATA READ
        gen2drv.get(data_trans);
        data_trans.display("DRIVER");
        data_from_memory = new[1];
        data_from_memory[0] = data_trans.data[0];
        axi_master_read(data_from_memory.size());




    endtask
    task write_axi_lite(input logic [31:0] addr, input logic [31:0] wdata, input logic [3:0] wstrb,
                        output logic [1:0] bresp);
        // ADDRESS PHASE
        @(posedge drv_axi_lite_if.aclk);
        drv_axi_lite_if.awaddr <= addr;
        drv_axi_lite_if.wdata  <= wdata;
        drv_axi_lite_if.wstrb  <= wstrb;
        drv_axi_lite_if.awvalid <= 1'b1;
        wait(drv_axi_lite_if.awready);
        #2;
        // DATA PHASE
        drv_axi_lite_if.wvalid <= 1'b1;
        wait(drv_axi_lite_if.wready);
        #2;
        drv_axi_lite_if.bready <= 1'b1;
        wait(drv_axi_lite_if.bvalid);
        bresp = drv_axi_lite_if.bresp;
        #2;
    endtask : write_axi_lite

    task axi_master_read(input int num_beats);
        // ADDRESS PHASE
        wait(drv_axi_slave_if.ar_valid_o);
        drv_axi_slave_if.ar_ready_i <= 1'b1;
        @(posedge drv_axi_slave_if.aclk);
        drv_axi_slave_if.ar_ready_i <= 1'b0;

        for(int i=0; i<num_beats; i++) begin
            drv_axi_slave_if.r_valid_i <= 1'b1;
            drv_axi_slave_if.r_data_i <= data_from_memory[i]; // desc_payload (src_addr, dest_addr, len_and_flag, nxt_desc)
            wait(drv_axi_slave_if.r_ready_o);
            @(posedge drv_axi_slave_if.aclk);
            
        end
        @(posedge drv_axi_slave_if.aclk);
        drv_axi_slave_if.r_valid_i <= 1'b0;
    endtask : axi_master_read
endclass
