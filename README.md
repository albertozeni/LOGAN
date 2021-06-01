<p align="center">
  <img width="585" height="460" src="https://github.com/albertozeni/logan/blob/master/media/logan.png">
</p>

## Introduction
<p align="justify">
Pairwise sequence alignment is one of the most computationally intensive kernels in genomic data analysis, accounting for more than 90% of the run time for key bioinformatics applications. This method is particularly expensive for third-generation sequences due to the high computational expense of analyzing these long read lengths (1Kb-1Mb). Given the quadratic overhead of exact pairwise algorithms such as Smith-Waterman, for long alignments the community primarily relies on approximate algorithms that search only for high-quality alignments and stop early when one is not found. In this work, we present the first GPU optimization of the popular X-drop alignment algorithm, named LOGAN.
</p>

## Usage

### Compilation

LOGAN requires CUDA 10 and C++14. To compile LOGAN simply type:
```
make demo v100=true
```
LOGAN has been optimized to run on the NVIDIA Tesla V100 (GB), but can run on any NVIDA GPU.
To compile to use other GPUs simply type:
```
make demo
```
This command disables Tesla V100 GPU optmization flags. 

### Demo
LOGAN generates an executable called **demo**.
To check everything has been compiled properly type:
```
./demo inputs_demo/example.txt 17 21 1
```
This command executes LOGAN on our example dataset with a k-mer length of 17, an X-drop value of 21 using a single GPU.
If everything executes correctly you can start using LOGAN with any input, any X-drop, and any number of GPUs.

The command line inputs are:
```
./demo [input] [k-mer-length] [X-drop] [#GPUS]
```
The input format for this demo is:
```
[seqV] [posV] [seqH] [posH] [strand]
```
**Each line of the input contains a pair of sequences to align**: the query sequence (seqV), the starting position of the seed on the query sequence (posV), the target sequence (seqH), the starting position of the seed on the target sequence (posH), and the relative strand ("c" if on opposite strands, "n" otherwise). Tab separated.

LOGAN has been incorporated as part of the [**BELLA**](https://github.com/giuliaguidi/bella) genomic pipeline. BELLA is a computationally efficient and highly accurate long-read to long-read aligner and overlapper. Users can optionally use LOGAN as pairwise alignment kernel.

## Performance Analysis

LOGAN and [SeqAn](https://github.com/seqan/seqan) execution times in seconds for 100K alignments (Power9 platform with 6 NVIDIA Tesla V100S).

| X-Drop 	| SeqAn 	| LOGAN (1 GPU) 	| LOGAN (6 GPUs) 	|
|--------:	|-------:	|---------------:	|----------------:	|
|   10  	|   5.1		|          	2.2 	|            1.9 	|
|   20  	|   12.7	|           3.1 	|            2.0 	|
|   50  	|   29.6	|           5.0 	|            2.2 	|
|   100  	|   45.7	|           7.2 	|            2.7 	|
|   500  	|   102.6	|           14.9 	|            4.0 	|
|   1000  	|   133.3	|           20.2 	|            4.9 	|
|   2500  	|   168.0	|           25.3 	|            5.5 	|
|   5000  	|   176.6	|           26.7 	|            5.8 	|

LOGAN and [ksw2](https://github.com/lh3/ksw2) execution times in seconds for 100K alignments ("Skylake" platform with 8 NVIDIA Tesla V100S).

| X-Drop 	| ksw2 		| LOGAN (1 GPU) 	| LOGAN (8 GPUs) 	|
|--------:	|-------:	|---------------:	|----------------:	|
|   10  	|   6.9		|          2.5		|            1.7 	|
|   20  	|   7.0		|          3.8		|            1.8 	|
|   50  	|   7.7		|          5.8		|            2.1 	|
|   100  	|   10.3	|          7.3		|            2.4 	|
|   500  	|   113.0	|          15.2		|            3.4 	|
|   1000  	|   209.5	|          20.4		|            4.3 	|
|   2500  	|   1235.8	|          25.9		|            5.2 	|
|   5000  	|   3213.1	|          27.2		|            5.2 	|

## Citation

To cite our work or to know more about our methods, please refer to:

> Zeni A, Guidi G, Ellis M, Ding N, Santambrogio MD, Hofmeyr S, Buluç A, Oliker L, Yelick K. [LOGAN: High-Performance GPU-Based X-Drop Long-Read Alignment](https://ieeexplore.ieee.org/abstract/document/9139808). 2020 IEEE International Parallel and Distributed Processing Symposium (IPDPS), pp. 462-471. IEEE, 2020.

## Copyright Notice
<p align="justify">
LOGAN: High-Performance X-Drop Pairwise Alignment on GPU (LOGAN) Copyright (c) 2019, The
Regents of the University of California, through Lawrence Berkeley National
Laboratory (subject to receipt of any required approvals from the U.S.
Dept. of Energy).  All rights reserved.
</p>

<p align="justify">
If you have questions about your rights to use or distribute this software,
please contact Berkeley Lab's Intellectual Property Office at
IPO@lbl.gov.
</p>

<p align="justify">
NOTICE.  This Software was developed under funding from the U.S. Department
of Energy and the U.S. Government consequently retains certain rights.  As
such, the U.S. Government has been granted for itself and others acting on
its behalf a paid-up, nonexclusive, irrevocable, worldwide license in the
Software to reproduce, distribute copies to the public, prepare derivative
works, and perform publicly and display publicly, and to permit other to do
so.
</p>

## Acknowledgments

Funding provided in part by DOE ASCR through the [Exascale Computing Project](https://www.exascaleproject.org/), and computing provided by [NERSC](https://www.nersc.gov/) and the [Oak Ridge Leadership Computing Facility](https://www.olcf.ornl.gov/). Thanks to Francesco Peverelli and Muaaz Awan for useful suggestions and valuable discussions.
