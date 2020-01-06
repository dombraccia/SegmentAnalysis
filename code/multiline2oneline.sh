#!/bin/bash
#SBATCH -J multi2one # Job name
#SBATCH --mail-user=dbraccia@terpmail.umd.edu # Email for job info
#SBATCH --mail-type=fail,end # Get email for begin, end, and fail
#SBATCH --time=11-00:00:00
#SBATCH --qos=large
#SBATCH --mem=128gb

##### TODO: MODIFY TO WORK IN SEGMENTANALYSIS PIPELINE

# a script for converting a multiline fasta file to a one life fasta file

# converting multi-line fasta to single line fasta file
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);} END {printf("\n");}' \
    data/all_complete_refseq_bac.fasta > data/all_complete_refseq_bac_oneline.fasta

rm data/all_complete_refseq_bac.fasta
mv data/all_complete_refseq_bac_oneline.fasta data/all_complete_refseq_bac.fasta
