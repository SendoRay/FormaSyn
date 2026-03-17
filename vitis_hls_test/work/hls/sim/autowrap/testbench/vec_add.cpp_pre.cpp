# 1 "/home/chengzhy/vitis_hls_test/vec_add.cpp"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 401 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "/home/chengzhy/vitis_hls_test/vec_add.cpp" 2
void vec_add(const int a[16], const int b[16], int c[16]) {
#pragma HLS PIPELINE II=1
        for (int i = 0; i < 16; i++) {
            c[i] = a[i] + b[i];
        }
    }
