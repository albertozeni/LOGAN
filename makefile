COMPILER = nvcc
CUDAFLAGS = -O3 -maxrregcount=32 -std=c++14 -Xcompiler -fopenmp
V100 = -arch=sm_70
demo: demo.cu
	$(COMPILER) $(CUDAFLAGS) demo.cu -o demo
demo_v100: demo.cu
	$(COMPILER) $(V100) $(CUDAFLAGS) demo.cu -o demo

clean:
	rm -f demo
	rm -f *.o