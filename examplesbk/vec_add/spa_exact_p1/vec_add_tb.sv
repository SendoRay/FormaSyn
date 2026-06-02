`timescale 1ns / 1ps

module vec_add_tb;

    // Clock: 250 MHz (period = 4 ns)
    reg clk = 0;
    always #2 clk = ~clk;

    reg rst_n = 0;
    reg start = 0;
    wire done;

    // ----- DUT inputs -----
    reg signed [7:0] a_0;
    reg signed [7:0] a_1;
    reg signed [7:0] a_2;
    reg signed [7:0] a_3;
    reg signed [7:0] a_4;
    reg signed [7:0] a_5;
    reg signed [7:0] a_6;
    reg signed [7:0] a_7;
    reg signed [7:0] a_8;
    reg signed [7:0] a_9;
    reg signed [7:0] a_10;
    reg signed [7:0] a_11;
    reg signed [7:0] a_12;
    reg signed [7:0] a_13;
    reg signed [7:0] a_14;
    reg signed [7:0] a_15;
    reg signed [7:0] b_0;
    reg signed [7:0] b_1;
    reg signed [7:0] b_2;
    reg signed [7:0] b_3;
    reg signed [7:0] b_4;
    reg signed [7:0] b_5;
    reg signed [7:0] b_6;
    reg signed [7:0] b_7;
    reg signed [7:0] b_8;
    reg signed [7:0] b_9;
    reg signed [7:0] b_10;
    reg signed [7:0] b_11;
    reg signed [7:0] b_12;
    reg signed [7:0] b_13;
    reg signed [7:0] b_14;
    reg signed [7:0] b_15;

    // ----- DUT outputs -----
    wire signed [6:0] c_0;
    wire signed [6:0] c_1;
    wire signed [6:0] c_2;
    wire signed [6:0] c_3;
    wire signed [6:0] c_4;
    wire signed [6:0] c_5;
    wire signed [6:0] c_6;
    wire signed [6:0] c_7;
    wire signed [6:0] c_8;
    wire signed [6:0] c_9;
    wire signed [6:0] c_10;
    wire signed [6:0] c_11;
    wire signed [6:0] c_12;
    wire signed [6:0] c_13;
    wire signed [6:0] c_14;
    wire signed [6:0] c_15;

    // ----- DUT instantiation -----
    vec_add dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .done(done),
        .a_0(a_0),
        .a_1(a_1),
        .a_2(a_2),
        .a_3(a_3),
        .a_4(a_4),
        .a_5(a_5),
        .a_6(a_6),
        .a_7(a_7),
        .a_8(a_8),
        .a_9(a_9),
        .a_10(a_10),
        .a_11(a_11),
        .a_12(a_12),
        .a_13(a_13),
        .a_14(a_14),
        .a_15(a_15),
        .b_0(b_0),
        .b_1(b_1),
        .b_2(b_2),
        .b_3(b_3),
        .b_4(b_4),
        .b_5(b_5),
        .b_6(b_6),
        .b_7(b_7),
        .b_8(b_8),
        .b_9(b_9),
        .b_10(b_10),
        .b_11(b_11),
        .b_12(b_12),
        .b_13(b_13),
        .b_14(b_14),
        .b_15(b_15),
        .c_0(c_0),
        .c_1(c_1),
        .c_2(c_2),
        .c_3(c_3),
        .c_4(c_4),
        .c_5(c_5),
        .c_6(c_6),
        .c_7(c_7),
        .c_8(c_8),
        .c_9(c_9),
        .c_10(c_10),
        .c_11(c_11),
        .c_12(c_12),
        .c_13(c_13),
        .c_14(c_14),
        .c_15(c_15)
    );

    initial begin
        rst_n = 0;
        start = 0;
        a_0 = 0;
        a_1 = 0;
        a_2 = 0;
        a_3 = 0;
        a_4 = 0;
        a_5 = 0;
        a_6 = 0;
        a_7 = 0;
        a_8 = 0;
        a_9 = 0;
        a_10 = 0;
        a_11 = 0;
        a_12 = 0;
        a_13 = 0;
        a_14 = 0;
        a_15 = 0;
        b_0 = 0;
        b_1 = 0;
        b_2 = 0;
        b_3 = 0;
        b_4 = 0;
        b_5 = 0;
        b_6 = 0;
        b_7 = 0;
        b_8 = 0;
        b_9 = 0;
        b_10 = 0;
        b_11 = 0;
        b_12 = 0;
        b_13 = 0;
        b_14 = 0;
        b_15 = 0;

        // Reset sequence
        #20;
        rst_n = 1;
        #10;

        // Apply test inputs
        a_0 = 8'd0;
        a_1 = 8'd1;
        a_2 = 8'd2;
        a_3 = 8'd3;
        a_4 = 8'd4;
        a_5 = 8'd5;
        a_6 = 8'd6;
        a_7 = 8'd7;
        a_8 = 8'd8;
        a_9 = 8'd9;
        a_10 = 8'd10;
        a_11 = 8'd11;
        a_12 = 8'd12;
        a_13 = 8'd13;
        a_14 = 8'd14;
        a_15 = 8'd15;
        b_0 = -8'd5;
        b_1 = -8'd3;
        b_2 = -8'd1;
        b_3 = 8'd1;
        b_4 = 8'd3;
        b_5 = 8'd5;
        b_6 = 8'd7;
        b_7 = 8'd9;
        b_8 = 8'd11;
        b_9 = 8'd13;
        b_10 = 8'd15;
        b_11 = 8'd17;
        b_12 = 8'd19;
        b_13 = 8'd21;
        b_14 = 8'd23;
        b_15 = 8'd25;

        // Assert start for one cycle
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        // Wait for completion (1 + 10 margin)
        repeat (11) @(posedge clk);

        // Capture outputs
        $display("@@OUTPUT c[%0d] = %0d", 0, c_0);
        $display("@@OUTPUT c[%0d] = %0d", 1, c_1);
        $display("@@OUTPUT c[%0d] = %0d", 2, c_2);
        $display("@@OUTPUT c[%0d] = %0d", 3, c_3);
        $display("@@OUTPUT c[%0d] = %0d", 4, c_4);
        $display("@@OUTPUT c[%0d] = %0d", 5, c_5);
        $display("@@OUTPUT c[%0d] = %0d", 6, c_6);
        $display("@@OUTPUT c[%0d] = %0d", 7, c_7);
        $display("@@OUTPUT c[%0d] = %0d", 8, c_8);
        $display("@@OUTPUT c[%0d] = %0d", 9, c_9);
        $display("@@OUTPUT c[%0d] = %0d", 10, c_10);
        $display("@@OUTPUT c[%0d] = %0d", 11, c_11);
        $display("@@OUTPUT c[%0d] = %0d", 12, c_12);
        $display("@@OUTPUT c[%0d] = %0d", 13, c_13);
        $display("@@OUTPUT c[%0d] = %0d", 14, c_14);
        $display("@@OUTPUT c[%0d] = %0d", 15, c_15);

        $finish;
    end

endmodule
