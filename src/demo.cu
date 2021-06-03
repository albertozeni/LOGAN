
//=========================================================
// Title:	LOGAN's Demo
// Authors:	A.Zeni, G. Guidi
//=========================================================

#include "logan.cuh"

using namespace std;

#define BATCH_SIZE 30000
#define GPU_THREADS 128

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
				int xdrop, int AlignmentsToBePerformed, int ngpus, int maxt)
{
	std::vector<int> 	posV(AlignmentsToBePerformed);
	std::vector<int> 	posH(AlignmentsToBePerformed);
	std::vector<SeedL> 	seeds(AlignmentsToBePerformed);
	std::vector<std::string> seqsV(AlignmentsToBePerformed);
	std::vector<std::string> seqsH(AlignmentsToBePerformed);
	std::vector<ScoringSchemeL> penalties(AlignmentsToBePerformed);
	ScoringSchemeL sscheme(1, -1, -1, -1);

	/* Pre-processing */
	for(int i = 0; i < AlignmentsToBePerformed; i++)
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
		penalties[i] = sscheme;
		/* starting position on seqsH, starting position on seqsV, k-mer/seed size */
		SeedL sseed(posH[i], posV[i], ksize);
		seeds[i] = sseed;
    }

	int numAlignmentsLocal = BATCH_SIZE * ngpus; 
	
	//	Divide the alignment in batches of 30K alignments
	for(int i = 0; i < AlignmentsToBePerformed; i += BATCH_SIZE * ngpus)
	{
		if(AlignmentsToBePerformed < (i + BATCH_SIZE * ngpus))
			numAlignmentsLocal = AlignmentsToBePerformed % (BATCH_SIZE * ngpus);

		int* res = (int*)malloc(numAlignmentsLocal * sizeof(int));	

		std::vector<string>::const_iterator first_t = seqsH.begin() + i;
		std::vector<string>::const_iterator last_t  = seqsH.begin() + i + numAlignmentsLocal;
		std::vector<string> target_b(first_t, last_t);

		std::vector<string>::const_iterator first_q = seqsV.begin() + i;
		std::vector<string>::const_iterator last_q  = seqsV.begin() + i + numAlignmentsLocal;
		std::vector<string> query_b(first_q, last_q);

		std::vector<SeedL>::const_iterator first_s = seeds.begin() + i;
		std::vector<SeedL>::const_iterator last_s  = seeds.begin() + i + numAlignmentsLocal;
		std::vector<SeedL> seeds_b(first_s, last_s);

		extendSeedL(seeds_b, EXTEND_BOTHL, target_b, query_b, penalties, xdrop, ksize, res, numAlignmentsLocal, ngpus, maxt);
		free(res);
	}
}

int main(int argc, char **argv)
{
	std::ifstream input(argv[1]);

	int ksize = atoi(argv[2]);	
	int xdrop = atoi(argv[3]);	
	int ngpus = atoi(argv[4]);

	/* Init the GPU environment */
	cudaFree(0);

	// @AlignmentsToBePerformed = alignments to be performed
	uint64_t AlignmentsToBePerformed = std::count(std::istreambuf_iterator<char>(input), std::istreambuf_iterator<char>(), '\n');
    input.seekg(0, std::ios_base::beg);

    /* Read input file */
	std::vector<std::string> entries;
    if(input)
        for (int i = 0; i < AlignmentsToBePerformed; ++i)
        {
            std::string line;
            std::getline(input, line);
            entries.push_back(line);
        }
    input.close();

	std::vector<std::vector<std::vector<std::string>>> local(GPU_THREADS);
	std::vector<std::vector<std::string>> alignments(AlignmentsToBePerformed);

	/* Pre-processing */
	#pragma omp parallel for
    for(uint64_t i = 0; i < AlignmentsToBePerformed; i++)
    {
		int tid = omp_get_thread_num();
        std::vector<std::string> tmp = split(entries[i], '\t');
        local[tid].push_back(tmp);
    }

	unsigned int alignmentssofar = 0;
	for(int tid = 0; tid < GPU_THREADS; ++tid)
	{
		copy(local[tid].begin(), local[tid].end(), alignments.begin() + alignmentssofar);
		alignmentssofar += local[tid].size();
	}

	/* Compute pairwise alignments */
	auto start = NOW;
   	LOGAN(alignments, ksize, xdrop, AlignmentsToBePerformed, ngpus, GPU_THREADS);	
	auto end = NOW;	
	std::chrono::duration<double> tot_time = end-start;
	double duration_tot = tot_time.count();


	std::cout<< "Total Execution time:\t"<< duration_tot <<std::endl;
   	return 0;
}


