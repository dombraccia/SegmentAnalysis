import sys
import pickle
import pandas as pd

print('- From gfa2tsv.py')

'''
This script is for extracting C-lines from the GFA file and then converting
them to some format (tsv, csv) that can easily be brought to a dataframe in R
and then to a GRanges object. Another key element of this script is that it 
also loads in segInfoDF to get the length of the segment in the current cline. 
It will then be overlayed over the genome annotation and things can be calculated 
then.
'''

# take in standard input from Snakefile
path2clines = sys.argv[1]
path2segInfoDF = sys.argv[2]
path2bedfile = sys.argv[3]

print('-- opening segInfoDF from pickle (need lengths of segments)')
segInfoDF = pickle.load(open(path2segInfoDF, 'rb'))

print('-- initialize the dataframe to store segment, start, end info')
segBED = pd.DataFrame(columns = ['genomeID', 'start', 'end', 'segmentID', 'score', 'strand'])

print('-- reading clines file line by line')
count = 0
with open(path2clines) as fh:
    for line in fh:
        # separating line into fields 
        current_line = line.strip().split()
        # current_line[1] # segment ID
        # current_line[2] # "strandedness" / regular VS reverse complement of segment 
        #                 # contained in genome
        # current_line[3] # genome contained in
        # current_line[5] # end position -100 bp (need to add 100 to get actual end)
        
        # calculate actual end position of the segment
        end_pos = int(current_line[5]) + 100
        
        # look up seg_length from segInfoDF
        seg_length = segInfoDF.loc[current_line[1], 'length_bp']

        # calculate start_pos from length and end_pos
        start_pos = (end_pos - seg_length)

        # input info into segBED dataframe (3 required and 2 extra fields)
        segBED.loc[count] = [current_line[3], start_pos, end_pos, current_line[1], "0", current_line[2]]

        count = count + 1

# save output to BED file
segBED.to_csv(path2bedfile, sep = '\t', index = False)
