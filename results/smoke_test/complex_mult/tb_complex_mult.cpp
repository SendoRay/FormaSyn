// Verilator C++ testbench for complex_mult
#include <cstdio>
#include <cstdlib>
#include <cstdint>
#include <cmath>
#include "Vcomplex_mult.h"
#include "verilated.h"

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vcomplex_mult* dut = new Vcomplex_mult;

    // Reset
    dut->clk = 0;
    dut->rst_n = 0;
    dut->valid_in = 0;
    dut->a = 0; dut->b = 0; dut->c = 0; dut->d = 0;

    for (int i = 0; i < 4; i++) {
        dut->clk = !dut->clk; dut->eval();
    }
    dut->rst_n = 1;

    // Test vectors
    struct TestVec { int16_t a, b, c, d; int32_t exp_re, exp_im; };

    // Pseudorandom test vectors (LCG, seed=42)
    const int NUM_TESTS = 200;
    TestVec tests[NUM_TESTS];
    uint32_t rng = 42;
    for (int i = 0; i < NUM_TESTS; i++) {
        rng = rng * 1664525 + 1013904223;  // LCG
        tests[i].a = (int16_t)(rng >> 16);
        rng = rng * 1664525 + 1013904223;
        tests[i].b = (int16_t)(rng >> 16);
        rng = rng * 1664525 + 1013904223;
        tests[i].c = (int16_t)(rng >> 16);
        rng = rng * 1664525 + 1013904223;
        tests[i].d = (int16_t)(rng >> 16);
        tests[i].exp_re = (int32_t)tests[i].a * tests[i].c - (int32_t)tests[i].b * tests[i].d;
        tests[i].exp_im = (int32_t)tests[i].a * tests[i].d + (int32_t)tests[i].b * tests[i].c;
    }

    int pass = 0, fail = 0;
    int out_idx = 0;
    int pipeline_latency = 2;  // 2-stage pipeline
    int cycle = 0;

    // Feed inputs and check outputs (accounting for pipeline latency)
    for (int i = 0; i < NUM_TESTS + pipeline_latency; i++) {
        // Rising edge
        dut->clk = 1;
        if (i < NUM_TESTS) {
            dut->valid_in = 1;
            dut->a = tests[i].a;
            dut->b = tests[i].b;
            dut->c = tests[i].c;
            dut->d = tests[i].d;
        } else {
            dut->valid_in = 0;
        }
        dut->eval();

        // Falling edge
        dut->clk = 0;
        dut->eval();

        // Check output after pipeline latency
        if (dut->valid_out && out_idx < NUM_TESTS) {
            int32_t got_re = (int32_t)dut->re_out;
            int32_t got_im = (int32_t)dut->im_out;
            int32_t exp_re = tests[out_idx].exp_re;
            int32_t exp_im = tests[out_idx].exp_im;

            if (got_re == exp_re && got_im == exp_im) {
                pass++;
            } else {
                fail++;
                if (fail <= 5) {
                    printf("FAIL[%d]: a=%d b=%d c=%d d=%d | expected re=%d im=%d | got re=%d im=%d\n",
                           out_idx, tests[out_idx].a, tests[out_idx].b,
                           tests[out_idx].c, tests[out_idx].d,
                           exp_re, exp_im, got_re, got_im);
                }
            }
            out_idx++;
        }
        cycle++;
    }

    printf("\n=== Complex Multiplier Test Results ===\n");
    printf("Total: %d  Pass: %d  Fail: %d\n", pass + fail, pass, fail);
    printf("Pass rate: %.1f%%\n", 100.0 * pass / (pass + fail));

    delete dut;
    return fail > 0 ? 1 : 0;
}
