#include <stdio.h>
#include <stdlib.h>
#include <data.h>
#include <gpuerrchk.h>

__global__ void kernel(data *obj, double* outarray, int numobj){
  int id = threadIdx.x + blockDim.x*blockIdx.x;
  obj[blockIdx.x].foo(threadIdx.x,outarray[id]);
}

int main(int argc, char* argv[]){
//test data for constructor
  double x = 2.0;
  int i = 2;
  int num = 10;
//N = number of data objects in the array
  int N=3;
  //data bar(x,i,num);
  data* pbar;
  pbar = (data*)malloc(sizeof(data)*N);
  for(int j=0;j<N;j++){
    data temp(x, j, num);
    pbar[j]=temp;} //each data object must be initialized with different input
  double *array = (double*)malloc(sizeof(double)*num*N);
  double *d_array;
  gpuErrchk(cudaMalloc((void**)&d_array, sizeof(double)*num*N));
  data *d_pbar;
  gpuErrchk(cudaMalloc(&d_pbar, N*sizeof(data)));
  gpuErrchk(cudaMemcpy(d_pbar, pbar, N*sizeof(data), cudaMemcpyHostToDevice));


  kernel<<<N,num>>>(d_pbar, d_array, N);

  gpuErrchk(cudaMemcpy(array,d_array,sizeof(double)*num*N,cudaMemcpyDeviceToHost));

  for(i=0;i<num*N;i++)
    printf("array[%d]=%6.2f\n",i,array[i]);

  free(array);
  gpuErrchk(cudaFree(d_array));

  return 0;
}
