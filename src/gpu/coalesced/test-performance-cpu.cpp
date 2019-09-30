
//========================================================================================================
// Title:  C++ program to assest quality and performance of LOGAN wrt to original SeqAn implementation
// Author: G. Guidi
// Date:   12 March 2019
//========================================================================================================
#define N_BLOCKS 5000 
//#include <omp.h>
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
#include <set>
#include <memory>
#include <typeinfo>
#include <pthread.h>
#include <vector>
#include <seqan/sequence.h>
#include <seqan/align.h>
#include <seqan/seeds.h>
#include <seqan/score.h>
#include <seqan/modifier.h>
//#include"logan.cuh"

using namespace std;
//using namespace seqan;

#define NOW std::chrono::high_resolution_clock::now()

//=======================================================================
// 
// Common functions
// 
//=======================================================================

//typedef seqan::Seed<seqan::Simple> TSeed;
typedef std::tuple< int, int, int, int, int, double > myinfo;	// score, start seedV, end seedV, start seedH, end seedH, runtime

char dummycomplement (char n)
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

vector<std::string> split (const std::string &s, char delim)
{
	std::vector<std::string> result;
	std::stringstream ss (s);
	std::string item;

	while (std::getline (ss, item, delim))
	{
		result.push_back (item);
	}

	return result;
}

//=======================================================================
// 
// SeqAn and LOGAN function calls
// 
//=======================================================================

typedef seqan::Seed<seqan::Simple> TSeed;
//typedef std::tuple< int, int, int, int, double > myinfo;	// score, start seed, end seed, runtime
// myinfo seqanXdrop(seqan::Dna5String& readV, seqan::Dna5String& readH, int posV, int posH, int mat, int mis, int gap, int kmerLen, int xdrop)
// {

// 	seqan::Score<int, seqan::Simple> scoringScheme(mat, mis, -2, gap);
// 	int score;
// 	myinfo seqanresult;

// 	std::chrono::duration<double>  diff;
// 	TSeed seed(posH, posV, kmerLen);

// 	// perform match extension	
// 	auto start = std::chrono::high_resolution_clock::now();
// 	score = seqan::extendSeed(seed, readH, readV, seqan::EXTEND_BOTH, scoringScheme, xdrop, seqan::GappedXDrop(), kmerLen);
// 	auto end = std::chrono::high_resolution_clock::now();
// 	diff = end-start;

// 	std::cout << "seqan score:\t" << score << "\tseqan time:\t" <<  diff.count() <<std::endl;
// 	//double time = diff.count();
// 	seqanresult = std::make_tuple(score, beginPositionV(seed), endPositionV(seed), beginPositionH(seed), endPositionH(seed), diff.count());
// 	return seqanresult;
// }

// typedef std::tuple< int, int, int, int, double > myinfo;	// score, start seed, end seed, runtime
void loganXdrop(std::vector< std::vector<std::string> > &v, int mat, int mis, int gap, int kmerLen, int xdrop)
{
	
	
	//Result result(kmerLen);
	int n_align = v.size();
	//int result;
	//myinfo loganresult;
	//vector<ScoringSchemeL> penalties(n_align);
	vector<int> posV(n_align);
	vector<int> posH(n_align);
	vector<string> seqV(n_align);
	vector<string> seqH(n_align);
	//vector<SeedL> seeds(n_align);
	for(int i = 0; i < v.size(); i++){
		//ScoringSchemeL tmp_sscheme(mat, mis, -1, gap);
		//penalties[i+j*v.size()]=tmp_sscheme;
		posV[i]=stoi(v[i][1]); 
		posH[i]=stoi(v[i][3]);		
		seqV[i]=v[i][0];		
		seqH[i]=v[i][2];
		std::string strand = v[i][4];

		if(strand == "c"){
			std::transform(
					std::begin(seqH[i]),
					std::end(seqH[i]),
					std::begin(seqH[i]),
					dummycomplement);
			posH[i] = seqH[i].length()-posH[i]-kmerLen;
		}
	}

	//seqan testbench
	seqan::Score<int, seqan::Simple> scoringScheme_s(mat, mis, -1, gap);
        cout<< "PERFORMING "<< n_align << " ALIGNMENTS"<<endl;
        int* scoreSeqAn;
	scoreSeqAn = (int*)malloc(n_align*sizeof(int));
        std::cout << "STARTING CPU" << std::endl;
        std::chrono::duration<double>  diff_s;
        vector<seqan::Dna5String> seqV_s_arr(n_align);
        vector<seqan::Dna5String> seqH_s_arr(n_align);
        TSeed* seed;
	seed = (TSeed*)malloc(n_align*sizeof(TSeed));
        for(int i = 0; i < n_align; i++){
                seqan::Dna5String seqV_s(seqV[i]);
                seqan::Dna5String seqH_s(seqH[i]);
                seqV_s_arr[i]=seqV_s;
                seqH_s_arr[i]=seqH_s;
                TSeed tmp(posH[i], posV[i], kmerLen);
                seed[i]=tmp;
        }
        auto start_s = std::chrono::high_resolution_clock::now();
        #pragma omp parallel for
	for(int i = 0; i < n_align; i++){
               	//printf("N threads: %d\n", omp_get_num_threads());
		scoreSeqAn[i] = seqan::extendSeed(seed[i], seqH_s_arr[i], seqV_s_arr[i], seqan::EXTEND_BOTH, scoringScheme_s, xdrop, seqan::GappedXDrop(), kmerLen);
        }
        auto end_s = std::chrono::high_resolution_clock::now();
        diff_s = end_s-start_s;
        cout << "SEQAN TIME:\t" <<  diff_s.count() <<endl;
}

//=======================================================================
//
// Function call main
//
//=======================================================================

int main(int argc, char **argv)
{
	// add optlist library later		
	ifstream input(argv[1]);		// file name with sequences and seed positions
	int kmerLen = atoi(argv[2]);	// kmerLen
	int xdrop = atoi(argv[3]);		// xdrop
	int mat = 1, mis = -1, gap = -1;	// GGGG: make these input parameters
	const char* filename =  (char*) malloc(20 * sizeof(char));
	std::string temp = "benchmark.txt"; // GGGG: make filename input parameter
	filename = temp.c_str();
	std::cout << "STARTING BENCHMARK" << std::endl;

	uint64_t numpair = std::count(std::istreambuf_iterator<char>(input), std::istreambuf_iterator<char>(), '\n');
	input.seekg(0, std::ios_base::beg);

	vector<std::string> entries;

	/* read input file */
	if(input)
		for (int i = 0; i < numpair; ++i)
		{
			std::string line;
			std::getline(input, line);
			entries.push_back(line);
		}
	input.close();
	// compute pairwise alignments
	vector< vector<string> > v(numpair);
	for(uint64_t i = 0; i < numpair; i++) 
	{
		
		//int ithread = i;//omp_get_thread_num();
		vector<string> temp = split(entries[i], '\t');
		// format: seqV, posV, seqH, posH, strand -- GGGG: generate this input with BELLA
		v[i]=temp;
	}
	loganXdrop(v, mat, mis, gap, kmerLen, xdrop);

	return 0;
}

