#!/bin/bash
#SBATCH -J ref_download # Job name
#SBATCH --mail-user=dbraccia@terpmail.umd.edu # Email for job info
#SBATCH --mail-type=fail # Get email for begin, end, and fail
#SBATCH --time=11-00:00:00
#SBATCH --qos=large
#SBATCH --mem=128gb

##### TODO: MODIFY TO WORK IN SEGMENTANALYSIS PIPELINE

# The following code is inspired from a BioStars question on how to download  #
# and parse bacterial reference sequences from RefSeq                         #

wget ftp://ftp.ncbi.nlm.nih.gov/genomes/genbank/bacteria/assembly_summary.txt
awk -F '\t' '{if($12=="Complete Genome") print $20 "/" $1 "_" $16 "_genomic.fna.gz"}' assembly_summary.txt > data/assembly_summary_complete_genomes.txt
rm assembly_summary.txt
mkdir -p data/refseq_genomes
ftp_links=`cat data/assembly_summary_complete_genomes.txt`
for next in $ftp_links; do wget -P data/refseq_genomes "$next"; done
gunzip data/refseq_genomes/*.gz
cat data/refseq_genomes/*.fna > data/all_complete_refseq_bac.fasta

# converting the genome sequences to single line format using existing script
bash code/multiline2oneline.sh 
