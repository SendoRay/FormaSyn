`timescale 1ns / 1ps

module ldpc_cnu_tb;

    // Clock: 250 MHz (period = 4 ns)
    reg clk = 0;
    always #2 clk = ~clk;

    reg rst_n = 0;
    reg start = 0;
    wire done;

    // ----- DUT inputs -----
    reg signed [7:0] msg_in_0;
    reg signed [7:0] msg_in_1;
    reg signed [7:0] msg_in_2;
    reg signed [7:0] msg_in_3;
    reg signed [7:0] msg_in_4;
    reg signed [7:0] msg_in_5;
    reg signed [7:0] msg_in_6;
    reg signed [7:0] msg_in_7;

    // ----- DUT outputs -----
    wire signed [1:0] sign_out_0;
    wire signed [1:0] sign_out_1;
    wire signed [1:0] sign_out_2;
    wire signed [1:0] sign_out_3;
    wire signed [1:0] sign_out_4;
    wire signed [1:0] sign_out_5;
    wire signed [1:0] sign_out_6;
    wire signed [1:0] sign_out_7;
    wire signed [2:0] min_out_0;
    wire signed [2:0] min_out_1;
    wire signed [2:0] min_out_2;
    wire signed [2:0] min_out_3;
    wire signed [2:0] min_out_4;
    wire signed [2:0] min_out_5;
    wire signed [2:0] min_out_6;
    wire signed [2:0] min_out_7;

    // ----- DUT instantiation -----
    ldpc_cnu dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .done(done),
        .msg_in_0(msg_in_0),
        .msg_in_1(msg_in_1),
        .msg_in_2(msg_in_2),
        .msg_in_3(msg_in_3),
        .msg_in_4(msg_in_4),
        .msg_in_5(msg_in_5),
        .msg_in_6(msg_in_6),
        .msg_in_7(msg_in_7),
        .sign_out_0(sign_out_0),
        .sign_out_1(sign_out_1),
        .sign_out_2(sign_out_2),
        .sign_out_3(sign_out_3),
        .sign_out_4(sign_out_4),
        .sign_out_5(sign_out_5),
        .sign_out_6(sign_out_6),
        .sign_out_7(sign_out_7),
        .min_out_0(min_out_0),
        .min_out_1(min_out_1),
        .min_out_2(min_out_2),
        .min_out_3(min_out_3),
        .min_out_4(min_out_4),
        .min_out_5(min_out_5),
        .min_out_6(min_out_6),
        .min_out_7(min_out_7)
    );

    initial begin
        rst_n = 0;
        start = 0;
        msg_in_0 = 0;
        msg_in_1 = 0;
        msg_in_2 = 0;
        msg_in_3 = 0;
        msg_in_4 = 0;
        msg_in_5 = 0;
        msg_in_6 = 0;
        msg_in_7 = 0;

        // Reset sequence
        #20;
        rst_n = 1;
        #10;

        // Apply test inputs
        msg_in_0 = 8'd2;
        msg_in_1 = -8'd2;
        msg_in_2 = 8'd1;
        msg_in_3 = -8'd3;
        msg_in_4 = 8'd2;
        msg_in_5 = -8'd1;
        msg_in_6 = 8'd4;
        msg_in_7 = -8'd2;

        // Assert start for one cycle
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        // Wait for completion (2 + 10 margin)
        repeat (12) @(posedge clk);

        // Capture outputs
        $display("@@OUTPUT sign_out[%0d] = %0d", 0, sign_out_0);
        $display("@@OUTPUT sign_out[%0d] = %0d", 1, sign_out_1);
        $display("@@OUTPUT sign_out[%0d] = %0d", 2, sign_out_2);
        $display("@@OUTPUT sign_out[%0d] = %0d", 3, sign_out_3);
        $display("@@OUTPUT sign_out[%0d] = %0d", 4, sign_out_4);
        $display("@@OUTPUT sign_out[%0d] = %0d", 5, sign_out_5);
        $display("@@OUTPUT sign_out[%0d] = %0d", 6, sign_out_6);
        $display("@@OUTPUT sign_out[%0d] = %0d", 7, sign_out_7);
        $display("@@OUTPUT min_out[%0d] = %0d", 0, min_out_0);
        $display("@@OUTPUT min_out[%0d] = %0d", 1, min_out_1);
        $display("@@OUTPUT min_out[%0d] = %0d", 2, min_out_2);
        $display("@@OUTPUT min_out[%0d] = %0d", 3, min_out_3);
        $display("@@OUTPUT min_out[%0d] = %0d", 4, min_out_4);
        $display("@@OUTPUT min_out[%0d] = %0d", 5, min_out_5);
        $display("@@OUTPUT min_out[%0d] = %0d", 6, min_out_6);
        $display("@@OUTPUT min_out[%0d] = %0d", 7, min_out_7);

        $finish;
    end

endmodule
