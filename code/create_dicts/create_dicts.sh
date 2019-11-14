#!/bin/bash
#SBATCH -J createDicts # Job name 
#SBATCH -o createDicts_%j.o # output file
#SBATCH -e createDicts_%j.e # error file
#SBATCH --mail-user=dfirer@terpmail.umd.edu # Email for job info
#SBATCH --mail-type=begin,fail,end # Get email for begin, end, and fail
#SBATCH --time=11-00:00:00                                                   
#SBATCH --qos=large 
#SBATCH --mem=128gb


python ./getplines.py
python ./dict.py
python ./dict_plus_minus.py
python ./dict_gen_counts.py
python ./dict_seg_counts.py