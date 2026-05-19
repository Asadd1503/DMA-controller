module resp_demux #(
    parameter N = 4
)(
    // From Controller
    input  logic                 resp_en,
    input  logic [2:0]           current_state, 
    input  logic [$clog2(N)-1:0] current_ch_id,

    // From 2x1 Arbiter
    input  logic                 read_done_in,
    input  logic                 write_done_in,
    input  logic                 read_error_in,
    input  logic                 write_error_in,
    input  logic                 datavalid_in,
    input  logic [127:0]         desc_data_in,

    // Outputs to Channel FSMs
    output logic [N-1:0]         read_done,
    output logic [N-1:0]         write_done,
    output logic [N-1:0]         read_error,
    output logic [N-1:0]         write_error,
    output logic [N-1:0]         desc_valid,
    output logic [127:0]         desc_data_out
);

    // State Encoding match from Controller
    localparam [2:0] DESC_RD = 3'b010;
    localparam [2:0] DATA_RD = 3'b100;
    localparam [2:0] DATA_WR = 3'b110;

    assign desc_data_out = desc_data_in; // Data flows through continuously

    always_comb begin
        // Default everything to 0
        read_done   = '0;
        write_done  = '0;
        desc_valid  = '0;
        read_error  = '0;
        write_error = '0;

        if (resp_en) begin
            // Route errors directly
            read_error[current_ch_id]  = read_error_in;
            write_error[current_ch_id] = write_error_in;

            // Differentiate done pulses based on state
            case (current_state)
                DESC_RD: begin
                    desc_valid[current_ch_id] = read_done_in;
                end
                DATA_RD: begin
                    read_done[current_ch_id]  = read_done_in;
                end
                DATA_WR: begin
                    write_done[current_ch_id] = write_done_in;
                end
                default: ; // Do nothing
            endcase
        end
    end

endmodule