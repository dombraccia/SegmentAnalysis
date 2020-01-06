#!/bin/bash
#SBATCH -J subset_genomes # Job name
#SBATCH --mail-user=dbraccia@terpmail.umd.edu # Email for job info
#SBATCH --mail-type=fail,end # Get email for begin, end, and fail
#SBATCH --time=11-00:00:00
#SBATCH --qos=large
#SBATCH --mem=128gb

##### TODO: MODIFY TO WORK IN SEGMENTANALYSIS PIPELINE

# getting seqs that say 'complete genome' and do not say plasmid
grep --no-group-separator -A1 'complete genome' data/all_complete_refseq_bac.fasta | \
   grep --no-group-separator -v 'plasmid' | \
   grep --no-group-separator -A1 'complete genome' > data/subset_complete_genome.fasta

# subsetting based on genus name 'Streptococcus'
grep --no-group-separator -A1 'Streptococcus' data/all_complete_refseq_bac.fasta > data/subset_Streptococcus.fasta
