
`ifndef AXI_LITE_TRANSACTION_SV
`define AXI_LITE_TRANSACTION_SV


class axi_lite_transaction;
    // transmitting signals
    bit [31:0] addr;
    bit [31:0] wdata;
    bit [3:0 ] wstrb;
    bit        is_write;
    // receiving signals
    bit [31:0] rdata;
    bit [1:0 ] bresp;

    function void display(string class_name);
        $display("%s: addr=%0h, wdata=%0h, wstrb=%0h, is_write=%b", class_name, addr, wdata, wstrb, is_write);
    endfunction

endclass

`endif 