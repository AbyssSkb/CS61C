#include "transpose.h"

/* The naive transpose function as a reference. */
void transpose_naive(int n, int blocksize, int* dst, int* src)
{
    for (int x = 0; x < n; x++) {
        for (int y = 0; y < n; y++) {
            dst[y + x * n] = src[x + y * n];
        }
    }
}

/* Implement cache blocking below. You should NOT assume that n is a
 * multiple of the block size. */
void transpose_blocking(int n, int blocksize, int* dst, int* src)
{
    // YOUR CODE HERE
    for (int i = 0; i < n; i += blocksize) {
        for (int j = 0; j < n; j += blocksize) {
            int x_end = i + blocksize;
            int y_end = j + blocksize;
            if (x_end > n) {
                x_end = n;
            }
            if (y_end > n) {
                y_end = n;
            }
            for (int x = i; x < x_end; x++) {
                for (int y = j; y < y_end; y++) {
                    dst[y + x * n] = src[x + y * n];
                }
            }
        }
    }
}
