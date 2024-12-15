#include <iostream>
#include <cstdlib>
#include <cassert>
#include <vector>
#include <functional>
#include <algorithm>

__global__ void matrixMul(const int *__restrict a, const int *__restrict b, int *__restrict c, int N)
{
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    c[row * N + col] = 0;
    for (int k = 0; k < N; k++)
    {
        c[row * N + col] += a[row * N + k] * b[k * N + col];
    }
}

int main()
{
    int N = 1 << 10;
    size_t bytes = N * N * sizeof(int);

    std::vector<int> h_a(N * N);
    std::vector<int> h_b(N * N);
    std::vector<int> h_c(N * N);

    std::generate(h_a.begin(), h_a.end(), []()
                  { return rand() % 100; });

    std::generate(h_b.begin(), h_b.end(), []()
                  { return rand() % 100; });

    int *d_a, *d_b, *d_c;
    cudaMalloc(&d_a, bytes);
    cudaMalloc(&d_b, bytes);
    cudaMalloc(&d_c, bytes);

    cudaMemcpy(d_a, h_a.data(), bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b.data(), bytes, cudaMemcpyHostToDevice);

    int threads_num = 32;
    int blocks_num = N / threads_num;

    dim3 threads(threads_num,threads_num);
    dim3 blocks(blocks_num,blocks_num);

    
}