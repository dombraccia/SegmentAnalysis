#!/bin/bash
#SBATCH -J python # Job name 
#SBATCH -o python_%j.o # output file
#SBATCH -e python_%j.e # error file
#SBATCH --mail-user=dbraccia@terpmail.umd.edu # Email for job info
#SBATCH --mail-type=fail,end # Get email for begin, end, and fail
#SBATCH --time=11-00:00:00
#SBATCH --qos=large 
#SBATCH --mem=128gb

# SCRIPT FOR RUNNING PYTHON SCRIPTS ON CLUSTER

# $1: give path to py script
time python -u $1
