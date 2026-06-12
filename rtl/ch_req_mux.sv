
module ch_req_mux #(
    parameter N = 4,
    parameter ADDR_WIDTH = 32,
    parameter LEN_WIDTH = 8
)(
    input  logic                 clk,
    input  logic                 rst_n,
    input  logic [$clog2(N)-1:0] current_ch_id,
    input  logic                 sel_en,

    // FIXED: Changed from Unpacked [0:N-1] to Packed [N-1:0] Arrays
    input  logic [N-1:0][ADDR_WIDTH-1:0] src_address,
    input  logic [N-1:0][ADDR_WIDTH-1:0] dest_address,
    input  logic [N-1:0][ADDR_WIDTH-1:0] desc_address,
    input  logic [N-1:0][LEN_WIDTH-1:0]  len,
    input  logic [N-1:0]                 type_in, // 1=Desc, 0=Data

    output logic [ADDR_WIDTH-1:0] sel_src,
    output logic [ADDR_WIDTH-1:0] sel_dest,
    output logic [ADDR_WIDTH-1:0] sel_desc_addr,
    output logic [LEN_WIDTH-1:0]  sel_len,
    output logic                  sel_type
);
    logic [31:0] desc_debug;
    assign desc_debug = desc_address[current_ch_id];
    //always_ff @(posedge clk or negedge rst_n) begin
    always_comb begin
    
        
    
        if (!rst_n) begin
            sel_src       <= '0;
            sel_dest      <= '0;
            sel_desc_addr <= '0;
            sel_len       <= '0;
            sel_type      <= '0;
        end else if(sel_en) begin
            // Indexing works exactly the same!
            sel_src       = src_address[current_ch_id];
            sel_dest      = dest_address[current_ch_id];
            sel_desc_addr = desc_address[current_ch_id];
            sel_len       = len[current_ch_id];
            sel_type      = type_in[current_ch_id];
        end
    end
    //$info("Selected desc_address: %0h", desc_address[current_ch_id]);

endmodule