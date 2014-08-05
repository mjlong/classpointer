#include <stdio.h>
#include <stdlib.h>
#include <data.h>
#include <gpuerrchk.h>

__global__ void kernel(data obj, double* outarray){
  int size = obj.msize;
  int id = (blockIdx.x*blockDim.x+threadIdx.x)%size;
  obj.foo(id,outarray[id%size]);
}

int main(int argc, char* argv[]){
//test data for constructor
  double x = 2.0;
  int i = 2;
  int num = 10;
//N = number of data objects in the array
  int N=2;
  //data bar(x,i,num);
  data** pbar;
  pbar = (data**)malloc(sizeof(data*)*N);
  for(int j=0;j<N;j++)
    pbar[j]=new data(x,i,num); //each data object must be initialized with different input
  double *array = (double*)malloc(sizeof(double)*num);
  double *d_array;
  gpuErrchk(cudaMalloc((void**)&d_array, sizeof(double)*num));
  

  kernel<<<16,16>>>(*pbar[0], d_array);
                   //only *pbar[0],namely type data works. Both data*, data** would fail. 
                   //It seems illegal to access host pointer data*, data** on device

  gpuErrchk(cudaMemcpy(array,d_array,sizeof(double)*num,cudaMemcpyDeviceToHost));

  for(i=0;i<num;i++)
    printf("array[%d]=%6.2f\n",i,array[i]);
  
  free(array);
  gpuErrchk(cudaFree(d_array));

  return 0;
}
