import defs::*;
module desc_counter (
    input logic clk,
    input logic rst_n,
    input logic desc_count_en_i,
    input logic ld_desc_cntr_i,
    output logic desc_count_done_o

);
logic [$clog2(DESC_NO_TRANSFERS):0] desc_count;
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        desc_count <= '0;
    end else if (ld_desc_cntr_i) begin
        desc_count <= DESC_NO_TRANSFERS;
    end
    else if (desc_count_en_i) begin
        desc_count <= desc_count - 1;
    end
end
assign desc_count_done_o = (desc_count == 0) ? 1 : 0;

    
endmodule