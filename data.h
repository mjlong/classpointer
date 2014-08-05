#ifndef __DATA_H__
#define __DATA_H__

class data{
  public:
    double* dptr;
    int*    iptr;
    int     msize;
  public:
    data(double,int,int);
    ~data();
    __device__ void foo(int,double&);
};

#endif
