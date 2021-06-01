//==================================================================
// Title:  Cuda x-drop seed-and-extend alignment algorithm
// Author: A. Zeni, G. Guidi
//==================================================================

#ifndef __LOGAN_FUNCTIONS_CUH__
#define __LOGAN_FUNCTIONS_CUH__

#include <string>
#include <iostream>
#include "seed.cuh"
#include "score.cuh"
#include <vector>
#include <omp.h>
#include <iterator>
#include <functional>
#include <numeric>

#define MIN -32768
#define BYTES_INT 4
#define MAX_GPUS 8
#define MATCH     1
#define MISMATCH -1
#define GAP_EXT  -1
#define GAP_OPEN -1
#define UNDEF -32767
#define WARP_DIM 32 
#define NOW std::chrono::high_resolution_clock::now()

enum ExtensionDirectionL
{
	EXTEND_NONEL  = 0,
	EXTEND_LEFTL  = 1,
	EXTEND_RIGHTL = 2,
	EXTEND_BOTHL  = 3
};

void extendSeedL(std::vector<SeedL> &seeds,
			ExtensionDirectionL direction,
			std::vector<std::string> &target,
			std::vector<std::string> &query,
			std::vector<ScoringSchemeL> &penalties,
			int const& XDrop,
			int const& kmer_length,
			int *res,
			int numAlignments,
			int ngpus,
			int n_threads
			);

#endif