#* gff2TxDb.R *#
args = commandArgs(trailingOnly=TRUE)
path2catGFFfile <- args[1]
path2scgtxdbout <- args[2]

## script for converting all .gff files for genomes into GRanges obects ##

##### ================= LOADING IN NECESSARY LIBRARIES ================== #####

suppressPackageStartupMessages(library(GenomicRanges))
suppressPackageStartupMessages(library(GenomicFeatures))

##### ================= CONVERTING CAT-ED GFF TO TXDB =================== #####

txdb <- GenomicFeatures::makeTxDbFromGFF(path2catGFFfile, format = "gff3")
txdb
saveDb(txdb, file = path2scgtxdbout)
