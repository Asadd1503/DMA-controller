
module rr_scheduler #(
    parameter N = 4
)(
    input  logic                 clk,
    input  logic                 rst_n,
    input  logic [N-1:0]         ch_req,        // Requests from all channels
    input  logic                 update_rr_ptr, // From Controller
    output logic [N-1:0]         grant,         // One-hot grant to FSMs
    output logic [$clog2(N)-1:0] current_ch_id  // Binary ID to datapath
);

    logic [$clog2(N)-1:0] ptr_q, ptr_n;
    logic [N-1:0]         mask, masked_req;
    logic [N-1:0]         grant_raw;
    
    // Create a mask to prioritize channels AFTER the current pointer
    assign mask = ~((1 << ptr_q) - 1);
    assign masked_req = ch_req & mask;

    // Find the next active request (Round Robin logic)
    always_comb begin
        grant_raw = '0;
        if (masked_req != 0) begin
            // Pick lowest bit in masked requests
            grant_raw = masked_req & ~(masked_req - 1);
        end else if (ch_req != 0) begin
            // Wrap around: pick lowest bit in all requests
            grant_raw = ch_req & ~(ch_req - 1);
        end
    end

    // Binary encoder to convert one-hot grant_raw to current_ch_id
    always_comb begin
        current_ch_id = '0;
        for (int i = 0; i < N; i++) begin
            if (grant_raw[i]) current_ch_id = i;
        end
    end

    // Assign final grant (held stable until update_rr_ptr)
    assign grant = grant_raw;

    // Pointer update logic
    always_comb begin
        ptr_n = ptr_q;
        if (update_rr_ptr) begin
            if (ptr_q == N-1) ptr_n = '0;
            else              ptr_n = ptr_q + 1;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) ptr_q <= '0;
        else        ptr_q <= ptr_n;
    end

endmodule