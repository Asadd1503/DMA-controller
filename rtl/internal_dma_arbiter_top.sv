
module internal_dma_arbiter_top #(
    parameter N = 4,
    parameter ADDR_WIDTH = 32,
    parameter LEN_WIDTH = 24
)(
    input  logic                 clk,
    input  logic                 rst_n,

    // --- INTERFACE 1: Channel FSMs ---
    input  logic [N-1:0]         ch_req,
    input  logic [N-1:0]         start_read,
    input  logic [N-1:0]         write_start,
    
    // FIXED: Packed Arrays
    input  logic [N-1:0][ADDR_WIDTH-1:0] src_address,
    input  logic [N-1:0][ADDR_WIDTH-1:0] dest_address,
    input  logic [N-1:0][ADDR_WIDTH-1:0] desc_address,
    input  logic [N-1:0][LEN_WIDTH-1:0]  len,
    input  logic [N-1:0]                 type_in,
    
    output logic [N-1:0]         grant,
    output logic [127:0]         desc_data_out,
    output logic [N-1:0]         desc_valid,
    output logic [N-1:0]         read_done,
    output logic [N-1:0]         write_done,
    output logic [N-1:0]         read_error,
    output logic [N-1:0]         write_error,

    // --- INTERFACE 2: 2x1 External Arbiter ---
    input  logic                 rd_master_idle,
    input  logic                 wr_master_idle,
    input  logic                 read_done_in,
    input  logic                 write_done_in,
    input  logic                 read_error_in,
    input  logic                 write_error_in,
    input  logic                 datavalid_in,
    input  logic [127:0]         desc_data_in,

    output logic [ADDR_WIDTH-1:0] src_address_o,
    output logic [ADDR_WIDTH-1:0] dest_address_o,
    output logic [ADDR_WIDTH-1:0] desc_address_o,
    output logic [LEN_WIDTH-1:0]  transfer_length_o,
    output logic                  start_read_i,
    output logic                  start_write_i,
    output logic                  desc_fetch_o
);

    // Internal Wires
    logic                 update_rr_ptr;
    logic [$clog2(N)-1:0] current_ch_id;
    logic                 sel_en;
    logic [ADDR_WIDTH-1:0] sel_src, sel_dest, sel_desc_addr;
    logic [LEN_WIDTH-1:0]  sel_len;
    logic                  sel_type;
    logic                 do_read_trigger, do_write_trigger;
    logic                 resp_en;
    logic                 route_desc, route_read, route_write;
   // logic [2:0]           fsm_state;

    // OR-reduce the control signals for the Controller
    logic ch_rq_any, start_read_any, write_start_any;
    
    assign ch_rq_any       = |ch_req;
    assign start_read_any  = |start_read;
    assign write_start_any = |write_start;

    // Instantiations
    rr_scheduler #(.N(N)) u_rr_scheduler (
        .clk(clk), .rst_n(rst_n), .ch_req(ch_req),
        .update_rr_ptr(update_rr_ptr), .grant(grant), .current_ch_id(current_ch_id)
    );

    ch_req_mux #(.N(N), .ADDR_WIDTH(ADDR_WIDTH), .LEN_WIDTH(LEN_WIDTH)) u_ch_mux (
        .clk(clk), .rst_n(rst_n), .current_ch_id(current_ch_id), .sel_en(sel_en),
        .src_address(src_address), .dest_address(dest_address), .desc_address(desc_address),
        .len(len), .type_in(type_in),
        .sel_src(sel_src), .sel_dest(sel_dest), .sel_desc_addr(sel_desc_addr),
        .sel_len(sel_len), .sel_type(sel_type)
    );

    master_intf_bridge #( .ADDR_WIDTH(ADDR_WIDTH), .LEN_WIDTH(LEN_WIDTH)) u_master_bridge (
        .do_read_trigger(do_read_trigger), .do_write_trigger(do_write_trigger),
        .sel_src(sel_src), .sel_dest(sel_dest), .sel_desc_addr(sel_desc_addr),
        .sel_len(sel_len), .sel_type(sel_type),
        .src_address_o(src_address_o), .dest_address_o(dest_address_o),
        .transfer_length(transfer_length_o), .start_read_i(start_read_i), .start_write_i(start_write_i),
        .desc_fetch_o(desc_fetch_o), .desc_address_o(desc_address_o)
    );

    resp_demux #(.N(N)) u_resp_demux (
        .resp_en(resp_en), .current_ch_id(current_ch_id),
        .read_done_in(read_done_in), .write_done_in(write_done_in), .read_error_in(read_error_in),
        .write_error_in(write_error_in), .datavalid_in(datavalid_in), .desc_data_in(desc_data_in),
        .read_done(read_done), .write_done(write_done), .read_error(read_error),
        .write_error(write_error), .desc_valid(desc_valid), .desc_data_out(desc_data_out),
        .route_desc(route_desc), .route_read(route_read), .route_write(route_write)
    );

    arbiter_controller u_controller (
        .clk(clk), .rst_n(rst_n), .ch_rq_any(ch_rq_any), .start_read(start_read_any),
        .write_start(write_start_any), .sel_type(sel_type),
        .rd_master_idle(rd_master_idle), .wr_master_idle(wr_master_idle),
        .read_done_in(read_done_in), .write_done_in(write_done_in),
        .sel_en(sel_en), .do_read_trigger(do_read_trigger), .do_write_trigger(do_write_trigger),
        .resp_en(resp_en), .update_rr_ptr(update_rr_ptr),
        .route_desc(route_desc), .route_read(route_read), .route_write(route_write)
    );

endmodule