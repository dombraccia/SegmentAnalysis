#!/bin/bash
#SBATCH -J pipeline # Job name 
#SBATCH -o pipeline_%j.o # output file
#SBATCH -e pipeline_%j.e # error file
#SBATCH --mail-user=dbraccia@terpmail.umd.edu # Email for job info
#SBATCH --mail-type=fail,end # Get email for begin, end, and fail
#SBATCH --time=21-00:00:00                                                   
#SBATCH --qos=xlarge 
#SBATCH --mem=495gb

#### a script to keep track of input & outputs for each step in the 
#### SegmentAnalysis pipeline

# TODO: MODIFY GENOME -> SEGMENT STEPS AS NEEDED

printf "- download reference sequences from NCBI - RefSeq \n  (NOTE: multiline2oneline.sh \n is called within this script)"
time bash ./download_refseq_genomes.sh 

printf "- subsetting complete reference genomes from full set"
time bash ./subset_selected_seqs.sh 

printf "- running twopaco & graphdump \n  (NOTE: split_tpcgd_outfile.sh is called within this script)"
time bash ./tpc_gd.sh de_Bruijn.bin 99 ../data/subset_complete_genome.fasta ../data/subset_complete_genome.gfa1

# =========================================================================== #

printf "- getting P-lines from .gfa1 file"
grep '^P' ../../data/scg_segments_k99.gfa1 >> ../data/plines.txt

printf "- generating raw segment / genome dictionaries"
time python -u ./dict.py

printf "- adding ubiquity, segment lengths, GC % info to dictionaries"
time python -u ./segment_lengths.py

printf "- converting saved dictionaries to pandas DataFrame and pickling"
time python -u ./dict_to_dataframe.py

printf "- adding column in genInfoDF to include # of unique segments"
time python -u ./uniq_segs.py

printf "- graphing histograms"
time python -u ./graph_segInfo.py
time python -u ./graph_genInfo.py

