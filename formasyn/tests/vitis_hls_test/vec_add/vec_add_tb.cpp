#include <iostream>
#include <cstdlib>

void vec_add(const int a[16], const int b[16], int c[16]);

int main() {
    int a[16], b[16], c[16];
    int golden[16];

    for (int i = 0; i < 16; i++) {
        a[i] = i;
        b[i] = i * 2;
        golden[i] = a[i] + b[i];
    }

    vec_add(a, b, c);

    int err = 0;
    for (int i = 0; i < 16; i++) {
        if (c[i] != golden[i]) {
            std::cout << "Mismatch at " << i
                      << ": got " << c[i]
                      << ", expected " << golden[i] << std::endl;
            err++;
        }
    }

    if (err == 0) {
        std::cout << "PASS" << std::endl;
        return 0;
    } else {
        std::cout << "FAIL, err = " << err << std::endl;
        return 1;
    }
}