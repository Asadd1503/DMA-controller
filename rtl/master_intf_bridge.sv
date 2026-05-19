module master_intf_bridge #(
    parameter ADDR_WIDTH = 32,
    parameter LEN_WIDTH = 8
)(
    // Inputs from Controller
    input  logic                  do_read_trigger,
    input  logic                  do_write_trigger,

    // Inputs from Block 2 (Mux)
    input  logic [ADDR_WIDTH-1:0] sel_src,
    input  logic [ADDR_WIDTH-1:0] sel_dest,
    input  logic [ADDR_WIDTH-1:0] sel_desc_addr,
    input  logic [LEN_WIDTH-1:0]  sel_len,
    input  logic                  sel_type, // 1 = Desc

    // Outputs to 2x1 External Arbiter
    output logic [ADDR_WIDTH-1:0] src_address_o,
    output logic [ADDR_WIDTH-1:0] dest_address_o,
    output logic [LEN_WIDTH-1:0]  desc_address_o,
    output logic [LEN_WIDTH-1:0]  transfer_length,
    output logic                  start_read_i,
    output logic                  start_write_i,
    output logic                  desc_fetch_o
);

    // Pass-through triggers
    assign start_read_i  = do_read_trigger;
    assign start_write_i = do_write_trigger;

    // Address selection logic
    always_comb begin
        /*  
        // If type is Descriptor (1), output desc_addr. Otherwise, output data src.
        if (sel_type == 1'b1) begin
            src_address_o = sel_desc_addr;
        end else begin
            src_address_o = sel_src;
        end
        */
        src_address_o   = sel_src; 
        dest_address_o  = sel_dest;
        desc_address_o  = sel_desc_addr;
        transfer_length = sel_len;
        desc_fetch_o    = sel_type;


    end

endmodule