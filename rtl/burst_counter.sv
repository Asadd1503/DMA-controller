
import defs::*;
module burst_counter #(
    parameter BURST_CNT_WIDTH = 2 
)(
    input  logic                        clk,
    input  logic                        rst_n,

    // control
    input  logic                        load,            // 1-cycle pulse: latch total_bursts
    input  logic [BURST_CNT_WIDTH:0]  total_bursts,    // from your pre-compute unit
    input logic                         count_en,
    // decrement trigger
    output logic                        burst_done      // 1-cycle pulse per completed burst
    // outputs
    //output logic [BURST_CNT_WIDTH:0]  bursts_remaining,
    
);

    logic [BURST_CNT_WIDTH:0] cnt;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= '0;
        end
        else if (load) begin
            // load takes priority over burst_done
            cnt <= total_bursts ;
        end
        else if (count_en) begin
            cnt <= cnt - 1'b1;
        end
    end

    // combinational outputs
    //assign bursts_remaining = cnt;
    assign burst_done = (cnt == 0) ? 1 : 0;

endmodule