COMPILER = nvcc
CUDAFLAGS = -O3 -maxrregcount=32 -std=c++14 -Isrc -Xcompiler -fopenmp
OBJS = src/demo.o src/seed.o src/score.o src/logan_functions.o
ifdef adapt
CUDAFLAGS+= -D ADAPTABLE
endif
ifdef v100 
CUDAFLAGS+= -arch=sm_70 
endif

demo: $(OBJS)
	$(COMPILER) $(CUDAFLAGS) $^ -o $@ 

%.o: %.cu
	$(COMPILER) -c $(CUDAFLAGS) -dc $< -o $@

.PHONY:clean
clean:
	rm -f demo
	rm -f src/*.o