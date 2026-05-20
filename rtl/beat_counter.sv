

module beat_counter #(
    parameter BEAT_CNT_WIDTH = 8 
)(
    input  logic                        clk,
    input  logic                        rst_n,

    // control
    input  logic                        load,            // 1-cycle pulse: latch total_bursts
    input  logic [BEAT_CNT_WIDTH-1:0]  total_beats,    // from your pre-compute unit
    input logic                         count_en,
    // decrement trigger
    output logic                        beat_done     // 1-cycle pulse per completed beat
    // outputs
    //output logic [BEAT_CNT_WIDTH-1:0]  beats_remaining,
    
);

    logic [BEAT_CNT_WIDTH-1:0] cnt;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= '0;
        end
        else if (load) begin
            // load takes priority over beat_done
            cnt <= total_beats ;
        end
        else if (count_en) begin
            cnt <= cnt - 1'b1;
        end
    end

    // combinational outputs
    //assign beats_remaining = cnt;
    assign beat_done = (cnt == 0) ? 1 : 0;

endmodule