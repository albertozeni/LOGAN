#include "score.cuh"

// return match score
int
__device__ __host__  scoreMatch(ScoringSchemeL const& me) {
	return me.match_score;
}

// individually set match score
void
setScoreMatch(ScoringSchemeL & me, int const& value) {
	me.match_score = value;
}

// return mismatch score
int
__device__ __host__ scoreMismatch(ScoringSchemeL const& me) {
	return me.mismatch_score;
}

// individually set mismatch score
void
setScoreMismatch(ScoringSchemeL & me, int const& value) {
	me.mismatch_score = value;
}

// return gap extension score
int
scoreGapExtend(ScoringSchemeL const& me) {
	return me.gap_extend_score;
}

// individually set gap extension score
void
setScoreGapExtend(ScoringSchemeL & me, int const& value) {
	me.gap_extend_score = value;
}

// return gap opening score
int
scoreGapOpen(ScoringSchemeL const& me) {
	return me.gap_open_score;
}

//returns the gap_open_score NB: valid only for linear gap
int 
__device__ __host__ scoreGap(ScoringSchemeL const & me){
	return me.gap_extend_score;
}

// individually set gap opening score
void
setScoreGapOpen(ScoringSchemeL & me, int const& value) {
	me.gap_open_score = value;
}

// set gap opening and gap extend scores
void
setScoreGap(ScoringSchemeL & me, int const& value) {
	me.gap_extend_score = value;
	me.gap_open_score = value;
}

int
__device__ __host__ score(ScoringSchemeL const & me, char valH, char valV) {
    if (valH == valV)
        return scoreMatch(me);
    else
        return scoreMismatch(me);
}