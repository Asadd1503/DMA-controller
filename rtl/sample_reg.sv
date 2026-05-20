import defs::*;
module sample_reg (
    input logic clk,
    input logic rst_n,
    input logic sample_en_i,
    input logic [DATA_W-1:0] data_in_i,
    output logic [128-1:0] data_out_o
);
always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out_o <= 128'b0;
        end else if (sample_en_i) begin
            // Shift the existing 96 bits to the left and append the new 32 bits
            // Oldest data is at the MSB [127:96], newest is at the LSB [31:0]
            data_out_o <= {data_out_o[95:0], data_in_i};
        end
    end
    
endmodule