
//========================================================================================================
// Title:  C++ program to assest quality and performance of LOGAN wrt to original SeqAn implementation
// Author: A. Zeni, G. Guidi
// Date:   12 March 2019
//========================================================================================================

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
#include"logan.cuh"

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
void loganXdrop(std::vector< std::vector<std::string> > &v, int mat, int mis, int gap, int kmerLen, int xdrop, int numpair, int gpus, int n_threads)
{
	
	
	//Result result(kmerLen);
	int n_align = v.size();
	//int result;
	//myinfo loganresult;
	vector<ScoringSchemeL> penalties(n_align);
	vector<int> posV(n_align);
	vector<int> posH(n_align);
	vector<string> seqV(n_align);
	vector<string> seqH(n_align);
	vector<SeedL> seeds(n_align);
	for(int i = 0; i < v.size(); i++){
                ScoringSchemeL tmp_sscheme(mat, mis, -1, gap);
                penalties[i]=tmp_sscheme;
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
		SeedL tmp_seed(posH[i], posV[i], kmerLen);
		seeds[i] = tmp_seed;
        }
	//seqan testbench
//	seqan::Score<int, seqan::Simple> scoringScheme_s(mat, mis, -1, gap);
        cout<< "PERFORMING "<< numpair << " ALIGNMENTS"<<endl;
        int* scoreLogan = (int*) malloc (sizeof(int)*numpair);
        std::chrono::duration<double>  diff_l;
        std::cout << "STARTING GPU" << std::endl;
        auto start_l = NOW;
        extendSeedL(seeds, EXTEND_BOTHL, seqH, seqV, penalties, xdrop, kmerLen, scoreLogan, numpair, gpus, n_threads);
        auto end_l = NOW;
        diff_l = end_l-start_l;

        cout << "LOGAN TIME:\t" <<  diff_l.count() <<endl;
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
	int n_threads = atoi(argv[4]);
	int gpus = atoi(argv[5]);  
	int mat = 1, mis = -1, gap = -1;	// GGGG: make these input parameters
	const char* filename =  (char*) malloc(20 * sizeof(char));
	//filename = temp.c_str();
	std::cout << "STARTING BENCHMARK" << std::endl;
	
	//setting up the gpu environment
	cudaFree(0);

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
        loganXdrop(v, mat, mis, gap, kmerLen, xdrop, numpair, gpus, n_threads);	

	return 0;
}

