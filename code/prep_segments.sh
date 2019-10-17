#!/bin/bash
#SBATCH -J prep_seg # Job name 
#SBATCH -o prep_segments_%j.o # output file
#SBATCH -e prep_segments_%j.e # error file
#SBATCH --mail-user=dbraccia@terpmail.umd.edu # Email for job info
#SBATCH --mail-type=fail,end # Get email for begin, end, and fail
#SBATCH --time=21-00:00:00                                                   
#SBATCH --qos=xlarge 
#SBATCH --mem=495gb

# Preparing metadata for parsing and analysis in python / GenomicRanges (R)

# go from "gfa" file to "bed" file using `gfa2fa` from `gfatools`
time ../external/gfatools/gfatools \
    gfa2bed -m ../data/scg_segments_k99.gfa1 > ../data/scg_segments_k99.bed
