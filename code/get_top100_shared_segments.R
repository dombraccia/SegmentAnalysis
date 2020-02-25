#/* get_top50_shared_segments.R */#

## WARNING: this script is very ad hoc right now and should probably not be done##
## in this way since I have to manually move the output and and then convert top##
## 100 shared segments flines to bed in another separate ad hoc script.         ##
## ============================================================================ ##
## A script for grabbing the top 50 shared segments from the segInfoDF and then ##
## doing overlap opperations on them                                            ##

# load libraries
library(GenomicRanges)
library(dplyr)

# loading data
segInfo <- read.csv("results/segInfoDF.csv")
segInfo

# subsetting based on most shared segments
segInfo_top100_shared <- top_n(segInfo, n = 100, wt = num_of_genomes)
top100_segIDs <- as.character(segInfo_top100_shared$X) # for now just manually grepping this to get line from data/flines.txt

# grep top 100 shared segs from the flines.txt file
for (id in seq_along(top100_segIDs)) {
   grep(top100_segIDs[id], "data/flines.txt")
}
grep(top100_segIDs)

# FOR NOW: GREP-ING TOP 100 SHARED SEGS MANUALLY AND CONVERTING F-LINES TO BED
# FILE FORMAT THEN DOING OVERLAPS