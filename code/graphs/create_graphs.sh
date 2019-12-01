#!/bin/bash
#SBATCH -J prelimGraphs # Job name 
#SBATCH -o prelimGraphs_%j.o # output file
#SBATCH -e prelimGraphs_%j.e # error file
#SBATCH --mail-user=dfirer@terpmail.umd.edu # Email for job info
#SBATCH --mail-type=fail,end # Get email for begin, end, and fail
#SBATCH --time=11-00:00:00                                                   
#SBATCH --qos=large 
#SBATCH --mem=128gb

#python ./graph_seg_to_gen.py
#python ./graph_gen_to_seg.py
python ./graph_count_of_gen.py
#python ./graph_count_of_seg.py
#python ./graph_plusVSminus.py