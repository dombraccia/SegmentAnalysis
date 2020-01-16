from os import remove
import json
from Bio import SeqIO
from Bio.SeqUtils import GC
import sys

'''
This script is for generating a dictionary of meta info about segments 
    and adding it to the existing dictionary containing genome counts.
Additional meta info So far:
    - length
    - GC content
TODO: other segment meta information to get?
'''

# initializing paths from input (from Snakefile)
path2seg_info = sys.argv[1]
path2gen_info = sys.argv[2]
path2segments_fasta = sys.argv[3]

# load in dictionary containing # of genomes from `dicts.py`
print('-- loading initial dictionary with # genomes per segment')
with open(path2seg_info) as segment_info:
    segments = json.load(segment_info) # now it is a dictionary I think
with open(path2gen_info) as genome_info:
    genomes = json.load(genome_info) # not being used in current state
print('--- there are:', len(segments.keys()), 'segments in the segments dictionary') # checking loaded segments dictionary
print('--- there are:', len(genomes.keys()), 'genomes in the genomes dictionary')

# From SeqIO documentation: https://biopython.org/wiki/SeqIO
print('-- adding: # of genomes, length of seg & GC % values to dictionary')
for i, record in enumerate(SeqIO.parse(path2segments_fasta, "fasta")):
    # add segment.id as key and length, GC content as values
    if i % 10000000 == 0:
        print('--- on segment number: ', str(i)) # check at every 1 mil iterations
    segments[record.id] = (segments[record.id], len(record), round(GC(record.seq)))

# saving the final segment info dictionary
print('-- saving final dictionary')
with open(path2seg_info, 'w') as output1:
    json.dump(segments, output1)

print('-- cleaning up intermediate files')
segment_info.close()
#os.remove('data/segment_info.json')
genome_info.close()
#os.remove('data/genome_info.json') 