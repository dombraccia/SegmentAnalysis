#!/bin/bash
#SBATCH -J ref_download # Job name
#SBATCH --mail-user=dbraccia@terpmail.umd.edu # Email for job info
#SBATCH --mail-type=fail # Get email for begin, end, and fail
#SBATCH --time=11-00:00:00
#SBATCH --qos=large
#SBATCH --mem=128gb

# The following code is inspired from a BioStars question on how to download  #
# and parse bacterial reference sequences from RefSeq                         #
#
# UPDATE 10-Feb-2020: I have also added a section of this script to download  #
# genome annotations for each reference originally downloaded                 # 

wget ftp://ftp.ncbi.nlm.nih.gov/genomes/genbank/bacteria/assembly_summary.txt
# awk -F '\t' '{if($12=="Complete Genome") print $20 "/" $1 "_" $16 "_genomic.fna.gz"}' \
#     assembly_summary.txt > data/scg_fna_ftp_links.txt # get full genomes
awk -F '\t' '{if($12=="Complete Genome") print $20 "/" $1 "_" $16 "_genomic.gff.gz"}' \
    assembly_summary.txt > data/scg_gff_ftp_links.txt # get genome annotations

## downloading the genomes
# mkdir -p data/refseq_genomes
# fna_ftp_links=`cat data/scg_fna_ftp_links.txt`
# for next in $fna_ftp_links; do wget -P data/refseq_genomes "$next"; done
# gunzip data/refseq_genomes/*.gz
# cat data/refseq_genomes/*.fna > data/all_complete_refseq_bac.fasta

## downloading the genome annotations
mkdir -p data/refseq_genome_annotations
gff_ftp_links=`cat data/scg_gff_ftp_links.txt`
for next in $gff_ftp_links; do wget -P data/refseq_genome_annotations "$next"; done
gunzip data/refseq_genome_annotations/*.gz
