#!/bin/bash
#SBATCH -J snake # Job name 
#SBATCH -o snake_%j.o # output file
#SBATCH -e snake_%j.e # error file
#SBATCH --mail-user=dbraccia@terpmail.umd.edu # Email for job info
#SBATCH --mail-type=fail,end # Get email for begin, end, and fail
#SBATCH --time=11-00:00:00
#SBATCH --qos=large 
#SBATCH --mem=128gb

# SCRIPT FOR RUNNING PYTHON SCRIPTS ON CLUSTER

# $1: give desired output of snakefile
# EXAMPLE CALL: sbatch submit_snakemake.sh data/subset_complete_genome.gfa1
time snakemake -p $1
