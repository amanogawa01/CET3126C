#include <stdio.h>
#include <cuda_runtime.h>

// Error checking macro
#define CHECK(call)                                                    \
{                                                                      \
    cudaError_t err = call;                                            \
    if (err != cudaSuccess) {                                          \
        fprintf(stderr, "CUDA Error: %s (err_num=%d) at %s:%d\n",      \
                cudaGetErrorString(err), err, __FILE__, __LINE__);     \
        exit(1);                                                       \
    }                                                                  \
}

__global__ void vectorAdd(const float* A, const float* B, float* C, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;

    if (i < n) {
        C[i] = A[i] + B[i];

        // Debug print for first few values
        if (i < 5) { 
            printf("GPU: Thread %d computed C[%d] = %f\n", threadIdx.x, i, C[i]);
        }
    }
}

int main() {
    int n = 1 << 10; // 1024 elements
    size_t size = n * sizeof(float);
    float *h_A = (float*)malloc(size);
    float *h_B = (float*)malloc(size);
    float *h_C = (float*)malloc(size);
    for (int i = 0; i < n; i++) {
        h_A[i] = i * 1.0f;
        h_B[i] = i * 2.0f;
    }

    float *d_A, *d_B, *d_C;

    CHECK(cudaMalloc(&d_A, size));
    CHECK(cudaMalloc(&d_B, size));
    CHECK(cudaMalloc(&d_C, size));

    // Copy input vectors to device
    CHECK(cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice));
    CHECK(cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice));

    int threadsPerBlock = 256;
    int blocks = (n + threadsPerBlock - 1) / threadsPerBlock;
    vectorAdd<<<blocks, threadsPerBlock>>>(d_A, d_B, d_C, n);
    CHECK(cudaDeviceSynchronize());
    CHECK(cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost));

    printf("Host: C[0] = %f\n", h_C[0]);
    printf("Host: C[n-1] = %f\n", h_C[n-1]);
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
    free(h_A);
    free(h_B);
    free(h_C);

    return 0;
}
