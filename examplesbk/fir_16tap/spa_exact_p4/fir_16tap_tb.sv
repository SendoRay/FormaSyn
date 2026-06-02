`timescale 1ns / 1ps

module fir_16tap_tb;

    // Clock: 250 MHz (period = 4 ns)
    reg clk = 0;
    always #2 clk = ~clk;

    reg rst_n = 0;
    reg start = 0;
    wire done;

    // ----- DUT inputs -----
    reg signed [7:0] x_in;

    // ----- DUT outputs -----
    wire signed [2:0] y_out;

    // ----- DUT instantiation -----
    fir_16tap dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .done(done),
        .x_in(x_in),
        .y_out(y_out)
    );

    initial begin
        rst_n = 0;
        start = 0;
        x_in = 0;

        // Reset sequence
        #20;
        rst_n = 1;
        #10;

        // Apply test inputs
        x_in = 8'd0;

        // Assert start for one cycle
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        // Wait for completion (5 + 10 margin)
        repeat (15) @(posedge clk);

        // Capture outputs
        $display("@@OUTPUT y_out = %0d", y_out);

        $finish;
    end

endmodule
