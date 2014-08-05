DIR_CUDA6 = /usr/local/cuda-6.0
CC=g++ #h5pcc #g++
NVCC = nvcc
ifeq ($(ver),debug)
NCFLAGS=-g -G -dc -arch=sm_20  -I. -I${DIR_CUDA6}/include
CCFLAGS=-c -g -I. -I${DIR_CUDA6}/include
else
NCFLAGS=      -dc -arch=sm_20  -I. -I${DIR_CUDA6}/include
CCFLAGS=   -c -I. -I${DIR_CUDA6}/include
endif
LINKLAG=-arch=sm_20 -dlink
LDFLAGS=-L${DIR_CUDA6}/lib64 -lcudart
GSOURCES=$(wildcard *.cu)
EXECUTABLE=classptr
CSOURCES=$(wildcard *.cpp)
COBJECTS=$(patsubst %.cpp, %.obj, $(notdir ${CSOURCES}))
GOBJECTS=$(patsubst %.cu, %.o  , $(notdir ${GSOURCES}))
LINKJECT=dlink.o      
all: $(EXECUTABLE)

$(EXECUTABLE): $(COBJECTS) $(GOBJECTS) $(LINKJECT)
	$(CC)  $^ $(LDFLAGS) -o $@
%.obj : %.cpp
	$(CC)              $(CCFLAGS) $^ -o $@
%.o : %.cu
	$(NVCC)   $(NCFLAGS)  $^ -o $@
$(LINKJECT) : $(GOBJECTS) 
	$(NVCC) $(LINKLAG) $^ -o $@
clean :  
	rm -rf *.o *.obj
