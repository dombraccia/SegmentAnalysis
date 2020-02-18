#* gff2TxDb.R *#
print("-- from gff2TxDb.R")
args = commandArgs(trailingOnly=TRUE)
path2catGFFfile <- args[1]
path2scgtxdbout <- args[2]

## script for converting all .gff files for genomes into GRanges obects ##

##### ================= LOADING IN NECESSARY LIBRARIES ================== #####

print("-- loading required packages")
suppressPackageStartupMessages(library(GenomicRanges))
suppressPackageStartupMessages(library(GenomicFeatures))

##### ================= CONVERTING CAT-ED GFF TO TXDB =================== #####

print("-- performing makeTxDbFromGFF step")
txdb <- GenomicFeatures::makeTxDbFromGFF(path2catGFFfile, format = "auto")
txdb

print("-- saving txdb object")
saveDb(txdb, file = path2scgtxdbout)
