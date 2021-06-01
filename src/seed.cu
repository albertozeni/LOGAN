#include "seed.cuh"

int
__device__ getAlignScore(SeedL const &myseed){
	return myseed.score;
}

int
__device__ __host__ getBeginPositionH(SeedL const &myseed){
	return myseed.beginPositionH;
}

int
__device__ __host__ getBeginPositionV(SeedL const &myseed){
	return myseed.beginPositionV;
}

int
__device__ __host__ getEndPositionH(SeedL const &myseed){
	return myseed.endPositionH;
}

int
__device__ __host__ getEndPositionV(SeedL const &myseed){
	return myseed.endPositionV;
}

int
__device__ getSeedLLength(SeedL const &myseed){
	return myseed.seedLength;
}

int
__device__ getLowerDiagonal(SeedL const &myseed){
	return myseed.lowerDiagonal;
}

int
__device__ getUpperDiagonal(SeedL const &myseed){
	return myseed.upperDiagonal;
}

int
__device__ getBeginDiagonal(SeedL const &myseed){
	return myseed.beginDiagonal;
}

int
__device__ getEndDiagonal(SeedL const &myseed){
	return myseed.endDiagonal;
}

void
__device__ setAlignScore(SeedL &myseed,int const value){
	myseed.score = value;
}

void
__device__ __host__ setBeginPositionH(SeedL &myseed,int const value){
	myseed.beginPositionH = value;
}

void
__device__ __host__ setBeginPositionV(SeedL &myseed,int const value){
	myseed.beginPositionV = value;
}

void
__device__ __host__ setEndPositionH(SeedL &myseed,int const value){
	myseed.endPositionH = value;
}

void
__device__ __host__ setEndPositionV(SeedL &myseed,int const value){
	myseed.endPositionV = value;
}

void
__device__ __host__ setSeedLLength(SeedL &myseed,int const value){
	myseed.seedLength = value;
}

void
__device__ __host__ setLowerDiagonal(SeedL &myseed,int const value){
	myseed.lowerDiagonal = value;
}

void
__device__ __host__ setUpperDiagonal(SeedL &myseed,int const value){
	myseed.upperDiagonal = value;
}

void
__device__ __host__ setBeginDiagonal(SeedL &myseed,int const value){
	myseed.beginDiagonal = value;
}

void
__device__ __host__ setEndDiagonal(SeedL &myseed,int const value){
	myseed.endDiagonal = value;
}