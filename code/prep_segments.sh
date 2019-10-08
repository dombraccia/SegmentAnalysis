#!/bin/bash
#SBATCH -J prep_seg # Job name 
#SBATCH -o /dev/null # suppress output file
#SBATCH -e /dev/null # suppress error file
#SBATCH --mail-user=dbraccia@terpmail.umd.edu # Email for job info
#SBATCH --mail-type=fail,end # Get email for begin, end, and fail
#SBATCH --time=18:00:00                                                   
#SBATCH --qos=throughput 
#SBATCH --mem=36gb

# Preparing metadata for parsing and analysis in python / GenomicRanges (R)

# go from "gfa" file to "fasta" file using `gfa2fa` from `gfatools`
time fs/cbcb-lab/hcorrada/SGVFinder/SegmentsAnalysis/external/gfatools/gfatools \
    gfa2bed -m 'path/to/gfa/file.gfa1' > 'path/to/BED/file.bed' 
