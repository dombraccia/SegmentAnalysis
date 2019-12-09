#!/bin/bash
#SBATCH -J pipeline # Job name 
#SBATCH -o pipeline_%j.o # output file
#SBATCH -e pipeline_%j.e # error file
#SBATCH --mail-user=dbraccia@terpmail.umd.edu # Email for job info
#SBATCH --mail-type=fail,end # Get email for begin, end, and fail
#SBATCH --time=21-00:00:00                                                   
#SBATCH --qos=xlarge 
#SBATCH --mem=495gb

# TODO: INCLUDE GENOME -> SEGMENT STEPS

#### a script to keep track of input & outputs for each step

echo '- getting P-lines from .gfa1 file'
grep '^P' ../../data/scg_segments_k99.gfa1 >> ../data/plines.txt

echo '- generating raw segment / genome dictionaries'
time python -u ./dict.py

echo '- adding ubiquity, segment lengths, GC % info to dictionaries'
time python -u ./segment_lengths.py

echo '- graphing things'
time python -u ./