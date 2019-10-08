# Script for doing segment analysis in R

# converting .bed file to GRanges object
library(rtracklayer)
gr <- rtracklayer::import('path/to/file')
