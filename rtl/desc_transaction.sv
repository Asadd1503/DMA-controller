
`ifndef DESC_TRANSACTION_SV
`define DESC_TRANSACTION_SV


class desc_transaction;
    bit [31:0] src_addr;
    bit [31:0] dest_addr;
    bit [31:0] len_and_flag;
    bit [31:0] nxt_desc;

    function void display(string class_name);
        $display("%s: src_addr=%0h, dest_addr=%0h, len_and_flag=%0h, nxt_desc=%0h", class_name, src_addr, dest_addr, len_and_flag, nxt_desc);
    endfunction

endclass
`endif 