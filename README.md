<p align="center">
  <img width="800" height="522" src="https://github.com/albertozeni/logan/blob/master/media/logan.jpeg">
</p>

# LOGAN

LOGAN: High-Performance X-Drop Pairwise Alignment on GPU

## Introduction
<p align="justify">
Pairwise sequence alignment is one of the most computationally intensive kernels in genomic data analysis, accounting for more than 90% of the run time for key bioinformatics applications. This method is particularly expensive for third-generation sequences due to the high computational expense of analyzing these long read lengths (1Kb-1Mb). Given the quadratic overhead of exact pairwise algorithms such as Smith-Waterman, for long alignments the community primarily relies on approximate algorithms that search only for high-quality alignments and stop early when one is not found. In this work, we present the first GPU optimization of the popular X-drop alignment algorithm, named LOGAN.
</p>

## Usage

### Compilation

LOGAN requires CUDA 10 and C++14

To compile LOGAN simply type:
```
make demo_v100
```
LOGAN has been optimized to run on the NVIDIA Tesla V100 (GB), but can run on any NVIDA GPU.
To compile to use other GPUs simply type:
```
make demo
```
This command disables Tesla V100 GPU optmimization flags. 

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

## Performance Analysis

## Copyright Notice

TBD

## Acknowledgments

Funding provided in part by DOE ASCR through the [Exascale Computing Project](https://www.exascaleproject.org/), and computing provided by [NERSC](https://www.nersc.gov/) and the [Oak Ridge Leadership Computing Facility](https://www.olcf.ornl.gov/). Thanks to Francesco Peverelli and Muaaz Awan for useful suggestions and valuable discussions.
