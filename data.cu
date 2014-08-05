#include "gpuerrchk.h"
#include "data.h"

data::data(double dinput, int iinput, int size){
  msize = size;
  gpuErrchk(cudaMalloc((void**)&dptr,sizeof(double)*size));
  gpuErrchk(cudaMalloc((void**)&iptr,sizeof(int)*size));
  double *h_dptr = (double*)malloc(sizeof(double)*size);
  int    *h_iptr = (int*)malloc(sizeof(int)*size);
  for(int j=0;j<size;j++){
    h_dptr[j] = dinput * (double)j;
    h_iptr[j] = iinput * j;
  }
  gpuErrchk(cudaMemcpy(dptr,h_dptr,sizeof(double)*size,cudaMemcpyHostToDevice));
  gpuErrchk(cudaMemcpy(iptr,h_iptr,sizeof(int)*size,cudaMemcpyHostToDevice));
  free(h_dptr);
  free(h_iptr);
}

data::~data(){
}

__device__ void data::foo(int input, double& output){
  output = iptr[input] + dptr[input];
}
