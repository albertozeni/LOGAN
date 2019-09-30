COMPILER = g++
COMPILER_GPU = nvcc
CC = gcc
CFLAGS = -I. -O3 -Wall -Wextra -pedantic -ansi -c -Wno-write-strings
SEQINCLUDE = -Iseqan
CUB = -Icub
CUDAFLAGS = -arch=sm_70 -O3 -maxrregcount=32 -std=c++14 -Xcompiler -fopenmp
ROOFLINE = -D ROOFLINE
ADAPT = -D ADAPTABLE

optlist.o:	../optlist/optlist.c ../optlist/optlist.h
	$(CC) $(CFLAGS) $<

test: test-performance-nosimd.cpp

	$(COMPILER) -std=c++14 $(INCLUDE) -O3 -march=native $(SEQINCLUDE) -o test test-performance-nosimd.cpp

gpu_c: test-performance-gpu-temp_cpp.cpp
	
	$(COMPILER) -std=c++14 $(INCLUDE) -O3 -march=native $(SEQINCLUDE) -o test test-performance-gpu-temp_cpp.cpp 

gpu_cori: test-performance-gpu.cu

	$(COMPILER_GPU) $(CUDAFLAGS) $(INCLUDE) $(SEQINCLUDE) test-performance-gpu.cu -o test

cpu_gpu: test-performance-gpu-cpu.cu

	$(COMPILER_GPU) $(CUDAFLAGS) $(INCLUDE) $(SEQINCLUDE) test-performance-gpu-cpu.cu -o test

cpu_openmp: test-performance-cpu.cpp

	$(COMPILER) -O3 -fopenmp -o test-cpu test-performance-cpu.cpp $(SEQINCLUDE) 

roofline:

	$(COMPILER_GPU) $(ROOFLINE) $(CUDAFLAGS) $(INCLUDE) $(SEQINCLUDE) test-performance-gpu.cu -o test

roofline_cpu:

	$(COMPILER) $(ROOFLINE) -O3 -o test-cpu test-performance-cpu.cpp $(SEQINCLUDE)

gpu_cori_ad: test-performance-gpu.cu

	$(COMPILER_GPU) $(CUDAFLAGS) $(INCLUDE) $(SEQINCLUDE) $(ADAPT) test-performance-gpu.cu -o test

clean:
	rm -f core
	rm -f *.o
	rm -f test
	rm -f test-cpu
	rm -f benchmark.txt
	rm -f test-cpu
	rm -f ../input-gen/gen
	rm -f roofline.txt	
