
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
        //this.rd_master_idle  = rd_master_idle;
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
        // DATA READ
        axi_master_read(data_from_memory.size());
        //wait(rd_master_idle);
        wait(drv_axi_slave_if.rd_master_idle_o);
        //$display("[ %0t ] rd_master_idle_o = %0d", $time, drv_axi_slave_if.rd_master_idle_o);
        // DATA WRITE
        axi_master_write(data_from_memory.size());
        $display("[ %0t ] wr_master_idle_o = %0d", $time, drv_axi_slave_if.wr_master_idle_o);
        wait(drv_axi_slave_if.wr_master_idle_o);   // error response has been wriiten to status reg,-> now reading error status.
        
        gen2drv.get(lite_trans);
        read_axi_lite(lite_trans.addr, lite_trans.rdata);
        if(lite_trans.rdata[1:0] == 2'b00) begin
        
            write_axi_lite(32'h14, 32'h10, 4'b1111, lite_trans.bresp); // wriiting okay response
        end
        else begin
            $display("[ %0t ] DMA ENCOuNTERED ERR0R", $time);
        end


    




    endtask
        task read_axi_lite(input logic [31:0] addr, output logic [31:0] rdata);
        // ADDRESS PHASE
        @(posedge drv_axi_lite_if.aclk);
        drv_axi_lite_if.araddr = addr;
        drv_axi_lite_if.arvalid = 1'b1;
        wait(drv_axi_lite_if.arready);
        //#2;
        @(posedge drv_axi_lite_if.aclk);
        drv_axi_lite_if.arvalid = 1'b0;
        // DATA PHASE
        drv_axi_lite_if.rready = 1'b1;
        wait(drv_axi_lite_if.rvalid);
        rdata = drv_axi_lite_if.rdata;
        repeat(2) @(posedge drv_axi_lite_if.aclk);
        drv_axi_lite_if.rready = 1'b0;
        //#2;
        
        endtask : read_axi_lite
    task write_axi_lite(input logic [31:0] addr, input logic [31:0] wdata, input logic [3:0] wstrb,
                        output logic [1:0] bresp);
        // ADDRESS PHASE
        @(posedge drv_axi_lite_if.aclk);
        drv_axi_lite_if.awaddr = addr;
        drv_axi_lite_if.wdata  = wdata;
        drv_axi_lite_if.wstrb  = wstrb;
        drv_axi_lite_if.awvalid = 1'b1;
        wait(drv_axi_lite_if.awready);
        @(posedge drv_axi_lite_if.aclk);
        drv_axi_lite_if.awvalid = 1'b0;
        //#2;
        // DATA PHASE
        drv_axi_lite_if.wvalid = 1'b1;
        wait(drv_axi_lite_if.wready);
        @(posedge drv_axi_lite_if.aclk);
        drv_axi_lite_if.wvalid = 1'b0;
        //#2;
        drv_axi_lite_if.bready = 1'b1;
        wait(drv_axi_lite_if.bvalid);
        bresp = drv_axi_lite_if.bresp;
        @(posedge drv_axi_lite_if.aclk);
        #2;
    endtask : write_axi_lite

    task axi_master_read(input int num_beats);
        // ADDRESS PHASE
        wait(drv_axi_slave_if.ar_valid_o);
        drv_axi_slave_if.ar_ready_i = 1'b1;
        @(posedge drv_axi_slave_if.aclk);
        drv_axi_slave_if.ar_ready_i = 1'b0;

        for(int i=0; i<num_beats; i++) begin
            drv_axi_slave_if.r_valid_i = 1'b1;
            drv_axi_slave_if.r_data_i = data_from_memory[i]; // desc_payload (src_addr, dest_addr, len_and_flag, nxt_desc)
            wait(drv_axi_slave_if.r_ready_o);
            @(posedge drv_axi_slave_if.aclk);
            
        end
        @(posedge drv_axi_slave_if.aclk);
        drv_axi_slave_if.r_valid_i = 1'b0;
    endtask : axi_master_read

    task axi_master_write(
        input int num_beats
    );
    wait(drv_axi_slave_if.aw_valid_o);
    drv_axi_slave_if.aw_ready_i = 1'b1;
    @(posedge drv_axi_slave_if.aclk);
    drv_axi_slave_if.aw_ready_i = 1'b0;
    for(int i=0; i<num_beats; i++) begin
        wait(drv_axi_slave_if.w_valid_o);
        drv_axi_slave_if.w_ready_i = 1'b1;
        @(posedge drv_axi_slave_if.aclk);
    end
    @(posedge drv_axi_slave_if.aclk);
    drv_axi_slave_if.w_ready_i = 1'b0;
    // send response
    wait(drv_axi_slave_if.b_ready_o);
    drv_axi_slave_if.b_valid_i = 1'b1;
    drv_axi_slave_if.b_resp_i = 2'b00; // OKAY
    @(posedge drv_axi_slave_if.aclk);

    endtask : axi_master_write
endclass
