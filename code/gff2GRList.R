#* gff2GRList.R *#
print("-- from gff2GRList.R")
args = commandArgs(trailingOnly=TRUE)
path2catGFFfile <- args[1]
path2scgGRList <- args[2]

## script for converting all .gff files for genomes into GRanges obects ##

##### ================= LOADING IN NECESSARY LIBRARIES ================== #####

print("-- loading required packages")
suppressPackageStartupMessages(library(GenomicRanges))
suppressPackageStartupMessages(library(GenomicFeatures))
suppressPackageStartupMessages(library(rtracklayer))

##### ================= CONVERTING CAT-ED GFF TO TXDB =================== #####

# print("-- performing makeTxDbFromGFF step")
# txdb <- GenomicFeatures::makeTxDbFromGFF(path2catGFFfile, format = "auto")
# txdb

# print("--- attempting rtracklayer::readGFF()")
# df <- rtracklayer::readGFF(path2catGFFfile)

# print("--- attempting GenomicFeatures::makeTxDbFromDataFrame()")
# txdb <- GenomicFeatures::makeTxDbFromDataFrame(df)
# txdb

# print("-- saving txdb object")
# saveDb(txdb, file = path2scgtxdbout)

print("--- reading in GFF files:")
files <- paste0("data/refseq_genome_annotations/", list.files(path="data/refseq_genome_annotations/"))
tmp_list <- list()
for (file in 1:length(files)) {
   tmp_list[[file]] <- rtracklayer::import(files[file])
   if (file == 1 | (file %% 100 == 0)) {
      print(paste("---- on gff number:", file))
   }
}
print("--- checking list output")
try(saveRDS(tmp_list, paste0(path2scgGRList, "_tmp")))

print("--- checking GRangesList output")
grList <- GRangesList(tmp_list) # causing OOM errors
saveRDS(grList, path2scgGRList)
