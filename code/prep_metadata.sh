#!/bin/bash
#SBATCH -J prep_meta # Job name 
#SBATCH -o /dev/null # suppress output file
#SBATCH -e /dev/null # suppress error file
#SBATCH --mail-user=dbraccia@terpmail.umd.edu # Email for job info
#SBATCH --mail-type=fail,end # Get email for begin, end, and fail
#SBATCH --time=18:00:00                                                   
#SBATCH --qos=throughput 
#SBATCH --mem=36gb

# Preparing metadata for parsing and analysis in python

### Extracting 'P' lines from .meta file
grep '^P' ../data/subset_complete_genome_segments_k99.meta \
    > tmp.txt

