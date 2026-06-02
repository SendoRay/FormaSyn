module fir_16tap (
    input wire clk,
    input wire rst_n,
    input wire start,
    output reg done,
    input wire signed [7:0] x_in,
    output reg signed [2:0] y_out
);

    // Pipeline: 5 stages, latency = 5 cycles

    // ----- internal signals -----
    reg signed [15:0] taps;
    reg signed [7:0] products;

    // ===== DATAPATH LOGIC (FALLBACK: scaffold-only) =====

endmodule
