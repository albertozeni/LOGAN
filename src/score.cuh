//==================================================================
// Title:  C++ x-drop seed-and-extend alignment algorithm
// Author: A. Zeni, G. Guidi
//==================================================================
#ifndef __SCORE_CUH__
#define __SCORE_CUH__


struct ScoringSchemeL
{
		int match_score;      // match
		int mismatch_score;   // substitution
		int gap_extend_score; // gap extension (indels)
		int gap_open_score;   // gap opening (indels)

		ScoringSchemeL()
				: match_score(1), mismatch_score(-1), gap_extend_score(-1), gap_open_score(-1) {
		}

		// liner gap penalty
		ScoringSchemeL(int match, int mismatch, int gap)
				: match_score(match), mismatch_score(mismatch),
					gap_extend_score(gap), gap_open_score(gap) {
		}

		// affine gap penalty
		ScoringSchemeL(int match, int mismatch, int gap_extend, int gap_open) 
				: match_score(match), mismatch_score(mismatch),
					gap_extend_score(gap_extend), gap_open_score(gap_open) {
		}
};

// return match score
int __device__ __host__  scoreMatch(ScoringSchemeL const& me);

// individually set match score
void setScoreMatch(ScoringSchemeL & me, int const& value);

// return mismatch score
int __device__ __host__ scoreMismatch(ScoringSchemeL const& me);

// individually set mismatch score
void setScoreMismatch(ScoringSchemeL & me, int const& value);

// return gap extension score
int scoreGapExtend(ScoringSchemeL const& me);

// individually set gap extension score
void setScoreGapExtend(ScoringSchemeL & me, int const& value);

// return gap opening score
int scoreGapOpen(ScoringSchemeL const& me);

//returns the gap_open_score NB: valid only for linear gap
int __device__ __host__ scoreGap(ScoringSchemeL const & me);

// individually set gap opening score
void setScoreGapOpen(ScoringSchemeL & me, int const& value);

// set gap opening and gap extend scores
void setScoreGap(ScoringSchemeL & me, int const& value);

int __device__ __host__ score(ScoringSchemeL const & me, char valH, char valV);

#endif