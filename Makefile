COMPILER = nvcc
CUDAFLAGS = -O3 -maxrregcount=32 -std=c++14 -Isrc -Xcompiler -fopenmp 
OBJS = src/demo.o src/seed.o src/score.o src/logan_functions.o

demo: $(OBJS)
ifdef v100
	$(COMPILER) $(CUDAFLAGS) -arch=sm_70 $^ -o $@ 
else
	$(COMPILER) $(CUDAFLAGS) $^ -o $@ 
endif

%.o: %.cu
ifdef v100
	$(COMPILER) -c $(CUDAFLAGS) -arch=sm_70 -dc $< -o $@
else
	$(COMPILER) -c $(CUDAFLAGS) -dc $< -o $@
endif
.PHONY:clean
clean:
	rm -f demo
	rm -f src/*.o