#/* find_overlaps.R */#
args = commandArgs(trailingOnly=TRUE)
path2gffGRList <- args[1]
path2top100sharedflines <- args[2]
path2outfile <- args[3]

## A script for doing overlap opperations on genome annotations and  ##
## top 100 shared segments                                           ##

print("-- loading libraries")
suppressPackageStartupMessages(library(GenomicRanges))
suppressPackageStartupMessages(library(dplyr))

print("-- loading data")
gff_ranges <- readRDS(path2gffGRList) # DONE (TODO: make into txdb obj by removing 'Name' fields from GFF files)
top100_df <- read.table(path2top100sharedflines, 
                        sep = "\t") # fine to just read in the flines file and treat it as a tsv

print("-- pre-processing of data")
# function to get last n characters of a string (works on vectors)
substrRight <- function(x, n){
    substr(x, nchar(x) - n + 1, nchar(x))
} 

# function to get everything but the last n characters of a string
substrLeft <- function(x, n){
    substr(x, 1, nchar(x) - n)
} 

# column rearrangements
top100_df <- top100_df[, -1] # removing 'F' column
top100_df$strand <- substrRight(as.character(top100_df$V3), 1) # creating strand col from V3
top100_df$genomeID <- substrLeft(as.character(top100_df$V3), 1) # creating genomeID col from V3
top100_df <- top100_df[, -(2:3)] # removing initial genomeID+strand and 0 column
colnames(top100_df) <- c("segmentID", "length", "start", "end", "overlap", "strand", "genomeID")

# checking class of end column
top100_df$end <- as.character(top100_df$end) # factor -> character -> integer ensures proper values
top100_df$end <- sub("[$]", "", top100_df$end) # some end fields have a '$' (probably denoting the end of a genome)
top100_df$end <- as.integer(top100_df$end) # converting character vector back to integer
# print(head(top100_df))
print(top100_df[191378:191380, ])
# print(paste0("--- the class of the $end column: ", class(top100_df$end)))
# print(paste0("--- the class of the $start column: ", class(top100_df$start)))

print("-- constructing the GRanges object")
top100_ranges <- GRanges(seqnames = top100_df$genomeID,
                         ranges = IRanges(start = top100_df$start,
                                          end = top100_df$end),
                                          #width = as.integer(substrLeft(as.character(top100_df$length), 1))),
                         strand = top100_df$strand,
                         segmentID = top100_df$segmentID
                         )

print("-- testing newly created gff_grlist and top100_granges objects")
head(gff_ranges)
head(top100_ranges)

print("-- perform overlap functions on two sets of ranges")

top100_gff_overlaps <- subsetByOverlaps(gff_ranges, top100_ranges)
saveRDS(top100_gff_overlaps, path2outfile)
