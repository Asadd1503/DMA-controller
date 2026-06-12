
import dma_pkg::axi_lite_transaction;
import dma_pkg::desc_transaction;
import dma_pkg::data_transaction;
class generator;
    mailbox gen2drv;
    function new(mailbox gen2drv);
        this.gen2drv = gen2drv;
    endfunction

    task run();
        axi_lite_transaction trans;
        desc_transaction desc_trans;
        data_transaction data_trans;
        trans = new();
        trans.is_write  = 1'b1;
        trans.addr      = 32'h04;     // desc_ptr_ch0
        trans.wdata     = 32'h1000;   // desc ptr = 32'h0000_1000;
        trans.wstrb     = 4'b1111;
        gen2drv.put(trans);
        trans = new();
        trans.is_write  = 1'b1;
        trans.addr      = 32'h00;     // 0x00 ch_en reg
        trans.wdata     = 32'h1;      // ch0_en
        trans.wstrb     = 4'b1111;
        gen2drv.put(trans);
        desc_trans = new();
        desc_trans.src_addr     = 32'h0000_0004;
        desc_trans.dest_addr    = 32'h0000_2000;
        desc_trans.len_and_flag  = 32'h0100_0004; // len=4 bytes, flag=1
        desc_trans.nxt_desc     = 32'h0000_0000; // nxt_desc = 32'h0000_0000;
        gen2drv.put(desc_trans);
        data_trans = new();
        data_trans.data = new[1];
        data_trans.data[0] = 32'hDEADBEEF;
        gen2drv.put(data_trans);
    endtask
endclass
