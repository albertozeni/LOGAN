# LOGAN

LOGAN: High-Performance X-Drop Pairwise Alignment on GPU

## Introduction
<p align="justify">
Pairwise sequence alignment is one of the most computationally intensive kernels in genomic data analysis, accounting for more than 90% of the run time for key bioinformatics applications. This method is particularly expensive for third-generation sequences due to the high computational expense of analyzing these long read lengths (1Kb-1Mb). Given the quadratic overhead of exact pairwise algorithms such as Smith-Waterman, for long alignments the community primarily relies on approximate algorithms that search only for high-quality alignments and stop early when one is not found. In this work, we present the first GPU optimization of the popular X-drop alignment algorithm, named LOGAN.
</p>

## Usage

### Compilation

TBD

### Demo

TBD

Demo's input format:
```
[seqV] [posV] [seqH] [posH] [strand]
```
**Each line of the input contains a pair of sequences to align**: the query sequence (seqV), the starting position of the seed on the query sequence (posV), the target sequence (seqH), the starting position of the seed on the target sequence (posH), and the relative strand ("c" if on opposite strands, "n" otherwise). Tab separated.

## Performance Analysis

## Copyright Notice

TBD

## Acknowledgments

Funding provided in part by DOE ASCR through the [Exascale Computing Project](https://www.exascaleproject.org/), and computing provided by [NERSC](https://www.nersc.gov/) and the Oak Ridge Leadership Computing Facility. Thanks to Francesco Peverelli and Muaaz Awan for useful suggestions and valuable discussions.
