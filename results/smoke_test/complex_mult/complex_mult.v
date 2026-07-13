// Complex Multiplier — Karatsuba (3-multiply) optimization
// (a+jb)(c+jd) = (ac-bd) + j(ad+bc)
// Karatsuba: k1=c(a+b), k2=a(d-c), k3=b(c+d) → Re=k1-k3, Im=k1+k2
//
// Input:  16-bit signed (1.15 fixed-point)
// Output: 32-bit signed (1.31 fixed-point)
// Pipeline: 2-stage for timing

module complex_mult #(
    parameter WIDTH = 16
)(
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    valid_in,
    input  wire signed [WIDTH-1:0] a,  // real part input 1
    input  wire signed [WIDTH-1:0] b,  // imag part input 1
    input  wire signed [WIDTH-1:0] c,  // real part input 2
    input  wire signed [WIDTH-1:0] d,  // imag part input 2
    output reg                     valid_out,
    output reg  signed [2*WIDTH-1:0] re_out,  // real part output
    output reg  signed [2*WIDTH-1:0] im_out   // imag part output
);

    // Stage 1: compute pre-additions and multiplications
    reg signed [WIDTH:0]     sum_ab;    // a + b (17-bit)
    reg signed [WIDTH:0]     diff_dc;   // d - c (17-bit)
    reg signed [WIDTH:0]     sum_cd;    // c + d (17-bit)
    reg signed [WIDTH-1:0]   c_r1, a_r1, b_r1;
    reg                      valid_s1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_ab  <= 0;
            diff_dc <= 0;
            sum_cd  <= 0;
            c_r1    <= 0;
            a_r1    <= 0;
            b_r1    <= 0;
            valid_s1 <= 0;
        end else begin
            sum_ab  <= {a[WIDTH-1], a} + {b[WIDTH-1], b};
            diff_dc <= {d[WIDTH-1], d} - {c[WIDTH-1], c};
            sum_cd  <= {c[WIDTH-1], c} + {d[WIDTH-1], d};
            c_r1    <= c;
            a_r1    <= a;
            b_r1    <= b;
            valid_s1 <= valid_in;
        end
    end

    // Stage 2: multiply and combine (Karatsuba)
    // k1 = c * (a+b), k2 = a * (d-c), k3 = b * (c+d)
    /* verilator lint_off UNUSEDSIGNAL */
    wire signed [2*WIDTH:0] k1_full = c_r1 * sum_ab;
    wire signed [2*WIDTH:0] k2_full = a_r1 * diff_dc;
    wire signed [2*WIDTH:0] k3_full = b_r1 * sum_cd;
    /* verilator lint_on UNUSEDSIGNAL */

    wire signed [2*WIDTH-1:0] k1 = k1_full[2*WIDTH-1:0];
    wire signed [2*WIDTH-1:0] k2 = k2_full[2*WIDTH-1:0];
    wire signed [2*WIDTH-1:0] k3 = k3_full[2*WIDTH-1:0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            re_out    <= 0;
            im_out    <= 0;
            valid_out <= 0;
        end else begin
            re_out    <= k1 - k3;
            im_out    <= k1 + k2;
            valid_out <= valid_s1;
        end
    end

endmodule
