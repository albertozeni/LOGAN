COMPILER = nvcc
CUDAFLAGS = -arch=sm_70 -O3 -maxrregcount=32 -std=c++14 -Xcompiler -fopenmp

demo: demo.cu
	$(COMPILER) $(CUDAFLAGS) demo.cu -o demo

clean:
	rm -f demo
	rm -f *.o