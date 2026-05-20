module sync_fifo #(
    parameter int DATA_WIDTH = 32,
    parameter int FIFO_DEPTH = 16
)(

    input  logic                    clk,
    input  logic                    rst_n,
    input  logic                    rst_fifo_i,
    input  logic                    wr_en,
    input  logic [DATA_WIDTH-1:0]   wr_data,
    input  logic                    rd_en,
    output logic [DATA_WIDTH-1:0]   rd_data,
    output logic                    full,
    output logic                    empty
    //output logic                    almost_full,
    //output logic                    almost_empty
    
);
logic [DATA_WIDTH-1:0] fifo_mem [0:FIFO_DEPTH-1];
localparam ADDR_WIDTH = $clog2(FIFO_DEPTH); 

    // The pointers are ADDR_WIDTH + 1 bits wide (the +1 is the extra MSB)
    logic [ADDR_WIDTH:0] wr_ptr;
    logic [ADDR_WIDTH:0] rd_ptr;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= '0;
            rd_ptr <= '0;
        end else if (rst_fifo_i) begin
            wr_ptr <= '0;
            rd_ptr <= '0;
        end else begin
            if (wr_en && !full)  begin
                wr_ptr                           <= wr_ptr + 1'b1;
                fifo_mem[wr_ptr[ADDR_WIDTH-1:0]] = wr_data;
            end
            if (rd_en && !empty) begin
                rd_ptr                          <= rd_ptr + 1'b1;
            end
        end
    end

    assign rd_data = fifo_mem[rd_ptr[ADDR_WIDTH-1:0]]; // Asynchronous output data

    assign empty = (wr_ptr == rd_ptr);

    assign full  = (wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]) && 
                   (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]);



endmodule