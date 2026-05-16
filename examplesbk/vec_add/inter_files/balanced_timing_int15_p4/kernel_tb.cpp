#include <cstdio>
#include <cmath>
#include "kernel.h"
#include <ap_int.h>
#include <ap_fixed.h>

void kernel(ap_int<8> a[16], ap_int<8> b[16], ap_int<15> c[16]);

int main() {
    ap_int<8> a[] = {(ap_int<8>)0, (ap_int<8>)1, (ap_int<8>)2, (ap_int<8>)3, (ap_int<8>)4, (ap_int<8>)5, (ap_int<8>)6, (ap_int<8>)7, (ap_int<8>)8, (ap_int<8>)9, (ap_int<8>)10, (ap_int<8>)11, (ap_int<8>)12, (ap_int<8>)13, (ap_int<8>)14, (ap_int<8>)15};
    ap_int<8> b[] = {(ap_int<8>)-5, (ap_int<8>)-3, (ap_int<8>)-1, (ap_int<8>)1, (ap_int<8>)3, (ap_int<8>)5, (ap_int<8>)7, (ap_int<8>)9, (ap_int<8>)11, (ap_int<8>)13, (ap_int<8>)15, (ap_int<8>)17, (ap_int<8>)19, (ap_int<8>)21, (ap_int<8>)23, (ap_int<8>)25};
    double golden_c[] = {-5, -2, 1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34, 37, 40};
    ap_int<15> c[16] = {0};
    kernel(a, b, c);

    int mismatch_count = 0;
    printf("@@OUTPUT c:");
    for (int i = 0; i < 16; i++) {
        if (i > 0) printf(",");
        printf("%.17g", (double)c[i]);
        mismatch_count += (std::fabs((double)c[i] - golden_c[i]) > 1e-9);
    }
    printf("\n");
    printf("@@MISMATCH %d\n", mismatch_count);
    return 0;
}
