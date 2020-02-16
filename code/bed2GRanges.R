#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
path2segbedfile <- args[1]
path2segGRangesout <- args[2]

## script for converting .bed files from segment c-lines into GRanges obects ##
## which then get converted to TxDb objects for comparison with gff TxDb obj ##
##                                                                           ##
## Overall: .gfa1 (c-lines) -> BED file (via gfa2bed.py) -> \                ##
## GRanges (via rtracklayer::import)                                         ##

##### ================= LOADING IN NECESSARY LIBRARIES ================== #####

library(GenomicRanges)
library(GenomicFeatures)

##### ============== LOADING DATA AND CONVERTING TO TXDB ================ #####

df <- read.csv(path2segbedfile, sep="")
colnames(df) <- c("seqnames", "start", "end", "name", "score", "strand")
gr <- makeGRangesFromDataFrame(df, keep.extra.columns = TRUE)
gr$type <- "segment"
#save gr object
write.table(x = data.frame(gr), file = path2segGRangesout,
            sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)

## apparently not doing GRanges -> txdb step ##
# txdb <- makeTxDbFromGRanges(gr)
# saveDb(txdb, file = path2segtxdbout)
## ========================================= ##                         