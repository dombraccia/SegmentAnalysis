#/* get_top50_shared_segments.R */#

## A script for grabbing the top 50 shared segments from the segInfoDF and then ##
## doing overlap opperations on them                                            ##

# load libraries

library(reticulate)
pd <- import("pandas")
pickle_data <- pd$read_pickle("results/all_ncbi_16S_segInfoDF.pickle")
pickle_data
