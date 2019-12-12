#!/bin/bash
#SBATCH -J subset_genomes # Job name
#SBATCH --mail-user=dbraccia@terpmail.umd.edu # Email for job info
#SBATCH --mail-type=fail,end # Get email for begin, end, and fail
#SBATCH --time=11-00:00:00
#SBATCH --qos=large
#SBATCH --mem=128gb

##### TODO: MODIFY TO WORK IN SEGMENTANALYSIS PIPELINE

# a script for cat-ing selected sequences from the master refseq fasta file
#module purger seqtk && module add seqtk
#seqtk subseq all_complete_refseq_bac.fasta chromosomes.txt > chromosomes.fasta 

# getting seqs that say 'complete genome' and do not say plasmid
#grep --no-group-separator -A1 'complete genome' all_complete_refseq_bac_oneline.fasta | \
#    grep --no-group-separator -v 'plasmid' | \
#    grep --no-group-separator -A1 'complete genome' > subset_complete_genome.fasta

# grabbing only the first 1000 genomes from this subset
#head -n 2000 subset_complete_genome.fasta > subset_complete_genome_small.fasta

# subsetting based on genus name 'Streptococcus'
grep --no-group-separator -A1 'Streptococcus' ../data/from-ncbi/all_complete_refseq_bac_oneline.fasta > ../data/from-ncbi/subset_Streptococcus.fasta

# testing with `sed`
#A=1 B=0 match='complete'
#cat test.fasta | grep -A1 'complete genome'
#sed -ne:t -e"/\n.*$match/D" \
#    -e'$!N;//D;/'"$match/{" \
#            -e"s/\n/&/$A;t" \
#            -e'$q;bt' -e\}  \
#    -e's/\n/&/'"$B;tP"      \
#    -e'$!bt' -e:P  -e'P;D'
