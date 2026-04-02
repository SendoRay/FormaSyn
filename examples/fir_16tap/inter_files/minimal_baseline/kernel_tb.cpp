#include <cstdio>
#include <cmath>
#include <ap_int.h>
#include <ap_fixed.h>
#include <hls_stream.h>

void kernel(
    ap_int<17> x_in[1],
    ap_fixed<25,3> y_out[1]
);

int main() {
    ap_int<17> x_in[] = {(ap_int<17>)(0.10000000000000001), (ap_int<17>)(0.29999999999999999), (ap_int<17>)(-0.5), (ap_int<17>)(0.80000000000000004), (ap_int<17>)(0.20000000000000001), (ap_int<17>)(-0.10000000000000001), (ap_int<17>)(0.40000000000000002), (ap_int<17>)(0.59999999999999998), (ap_int<17>)(-0.29999999999999999), (ap_int<17>)(0.69999999999999996), (ap_int<17>)0, (ap_int<17>)(-0.20000000000000001), (ap_int<17>)(0.5), (ap_int<17>)(-0.40000000000000002), (ap_int<17>)(0.90000000000000002), (ap_int<17>)(-0.59999999999999998)};
    double golden_y_out[] = {2.3999999999999999};
    ap_fixed<25,3> y_out[1] = {0};
    kernel(x_in, y_out);

    int mismatch_count = 0;
    printf("@@OUTPUT y_out:");
    for (int i = 0; i < 1; i++) {
        if (i > 0) printf(",");
        printf("%.17g", (double)y_out[i]);
        mismatch_count += (std::fabs((double)y_out[i] - golden_y_out[i]) > 1e-9);
    }
    printf("\n");
    printf("@@MISMATCH %d\n", mismatch_count);
    return 0;
}
