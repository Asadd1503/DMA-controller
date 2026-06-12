class data_transaction;
    bit [31:0] data [];
    
    function void display(string class_name);
    
        for (int i=0; i<data.size(); i++) begin
            $display("%s: data[%0d]=%0h", class_name, i, data[i]);
        end
    endfunction

endclass