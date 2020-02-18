#!/bin/bash

# unfortunately, this needs to be hard coded for now since you can't give a 
# string of a directory as input for a snakemake rule
GFF_FILES=data/refseq_genome_annotations/*.gff

# rm -f $1 # snakemake wouldn't run anyway if the finished file was there
printf "-- looping over gff files and cat-ing"
for f in $GFF_FILES
do
    # echo $f
    cat $f >> $1 
done

# since we are going with "hard coded" stuff, it turns out that these regions
# are causing errors when trying to go from gff file to txdb object, so they
# need to be removed from the gff file (for now). The error from
# `GenomicFeatures::makeTxDbFromGFF()`` was:
# source ~/.bash_profile; module load R/3.6.1; Rscript code/gff2TxDb.R data/scg_annotations.gff results/scg_txdb.sqlite
#   Import genomic features from the file as a GRanges object ... OK
#   Prepare the 'metadata' data frame ... OK
#   Make the TxDb object ... Error in .merge_transcript_parts(transcripts) : 
#       The following transcripts have multiple parts that cannot be merged
#       because of incompatible Name: gene-OENI_0019, gene-OENI_0020, ...

printf "-- removing problematic lines from cat-ed gff file"
grep -vif data/scg_gff_problem_lines.txt $1 > tmp.file
mv tmp.file $1 
