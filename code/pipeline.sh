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

echo '- download reference sequences from NCBI - RefSeq'
time bash ./download_refseq_genomes.sh #TODO: NEEDS MODIFICATION

echo '- convert multiline reference genomes to single line'
time bash ./multiline2oneline.sh #TODO: NEEDS MODIFICATION

echo '- subsetting complete reference genomes from full set'
time bash ./subset_selected_seqs.sh #TODO: NEEDS MODIFICATION

echo '- running twopaco && graphdump (NOTE: split_tpcgd_outfile.sh is called within this script'
time bash ./tpc_gd.sh #TODO: NEEDS MODIFICATION

# =========================================================================== #

echo '- getting P-lines from .gfa1 file'
grep '^P' ../../data/scg_segments_k99.gfa1 >> ../data/plines.txt

echo '- generating raw segment / genome dictionaries'
time python -u ./dict.py

echo '- adding ubiquity, segment lengths, GC % info to dictionaries'
time python -u ./segment_lengths.py

echo '- converting saved dictionaries to pandas DataFrame and pickling'
time python -u ./dict_to_dataframe.py

echo '- adding column in genInfoDF to include # of unique segments'
time python -u ./uniq_segs.py

echo '- graphing histograms'
time python -u ./graph_segInfo.py
time python -u ./graph_genInfo.py

