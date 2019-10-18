
//=========================================================
// Title:	LOGAN's Demo
// Author:	G. Guidi
// Created:	12 March 2019
// Last modified: 18 October 2019
//=========================================================

#include <omp.h>
#include <chrono>
#include <fstream>
#include <iostream>
#include <string>
#include <cstdlib>
#include <cstdio>
#include <algorithm>
#include <cmath>
#include <numeric>
#include <vector>
#include <sys/types.h> 
#include <sys/stat.h> 
#include <math.h>
#include <limits.h>
#include <bitset>
#include <map>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <ctype.h> 
#include <sstream>
#include <cassert>
#include <set>
#include <memory>
#include <typeinfo>
#include <vector>

#ifdef __NVCC__
	#include "src/gpu/coalesced/logan.cuh"
#endif

/* nucleotide complement */
char basecomplement (char n)
{	
	switch(n)
	{   
	case 'A':
		return 'T';
	case 'T':
		return 'A';
	case 'G':
		return 'C';
	case 'C':
		return 'G';
	}	
	assert(false);
	return ' ';
}

std::vector<std::string> split(const std::string &s, char delim)
{
	std::vector<std::string> result;
	std::stringstream ss(s);
	std::string item;

	while (std::getline(ss, item, delim))
		result.push_back(item);

	return result;
}

/* LOGAN's function call */
void LOGAN(std::vector<std::vector<std::string>> &alignments, int ksize, 
				int xdrop, int num, int ngpus, int maxt)
{
	std::vector<int> 	posV(num);
	std::vector<int> 	posH(num);
	std::vector<SeedL> 	seeds(num);
	std::vector<std::string> seqsV(num);
	std::vector<std::string> seqsH(num);
	std::vector<ScoringSchemeL> penalties(num);

	/* Pre-processing */
	for(int i = 0; i < num; i++)
	{
        posV[i]	 =	std::stoi(alignments[i][1]);
        posH[i]	 =	std::stoi(alignments[i][3]);
        seqsV[i] =	alignments[i][0];
        seqsH[i] =	alignments[i][2];
        std::string strand = alignments[i][4];

		/* Reverse complement */
        if(strand == "c")
		{
            std::transform(
                std::begin(seqsH[i]),
                std::end(seqsH[i]),
                std::begin(seqsH[i]),
                basecomplement);
            posH[i] = seqsH[i].length()-posH[i]-ksize;
        }

		/* match, mismatch, gap opening, gap extension */ 
		ScoringSchemeL sscheme(1, -1, -1, -1);
		penalties[i] = sscheme;
		SeedL sseed(posH[i], posV[i], ksize);
		seeds[i] = sseed;
    }

    int* results = (int*)malloc(sizeof(int)*num);
	/* TODO: maxt not used */
	/* Batch alignment on GPU */
    extendSeedL(seeds, EXTEND_BOTHL, seqsH, seqsV, penalties, xdrop, ksize, results, num, ngpus, maxt);
}

int main(int argc, char **argv)
{
	std::ifstream input(argv[1]);

	int ksize = atoi(argv[2]);	
	int xdrop = atoi(argv[3]);	
	int ngpus = atoi(argv[5]);

	int maxt = 1;
	#pragma omp parallel
	{
		maxt = omp_get_num_threads();
	}

	/* Init the GPU environment */
	cudaFree(0);

	uint64_t num = std::count(std::istreambuf_iterator<char>(input), std::istreambuf_iterator<char>(), '\n');
    input.seekg(0, std::ios_base::beg);

    /* Read input file */
	std::vector<std::string> entries;
    if(input)
        for (int i = 0; i < num; ++i)
        {
            std::string line;
            std::getline(input, line);
            entries.push_back(line);
        }
    input.close();

	std::vector<std::vector<std::vector<std::string>>> local(maxt);
	std::vector<std::vector<std::string>> alignments(num);

	/* Pre-processing */
	#pragma omp parallel for
    for(uint64_t i = 0; i < num; i++)
    {
		int tid = omp_get_thread_num();
        std::vector<std::string> tmp = split(entries[i], '\t');
        local[tid].push_back(tmp);
    }

	unsigned int alignmentssofar = 0;
	for(int tid = 0; tid < maxt; ++tid)
	{
		copy(local[tid].begin(), local[tid].end(), alignments.begin() + alignmentssofar);
		alignmentssofar += local[tid].size();
	}

	/* Compute pairwise alignments */
   	LOGAN(alignments, ksize, xdrop, num, ngpus, maxt);	
		
   	return 0;
}


