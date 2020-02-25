import json
import pickle
import time
import sys

'''
A script for figuring out how many segments are unique per genome.
TODO: Get lengths of these uniq segments
'''

# take standard input from Snakefile
path2genomes_json = sys.argv[1]
path2genInfoDF_tmp = sys.argv[2]
path2uniqSegInfoDF = sys.argv[3]
path2genInfoDF = sys.argv[4]

# import data
print('-- opening large data files')
t = time.time()
with open(path2genomes_json) as genomes_json:
    genomes = json.load(genomes_json)
elapsed = time.time() - t
print('---- time elapsed:', round(elapsed/60, 2), "min")

print('-- loading genome and unique segments info dataframes (also large)')
t = time.time()
genInfoDF = pickle.load(open(path2genInfoDF_tmp, 'rb')) # takes far too long to load into memory
uniqSegInfoDF = pickle.load(open(path2uniqSegInfoDF, 'rb'))
elapsed = time.time() - t
print('---- time elapsed:', round(elapsed/60, 2), "min")

# checking which segments are unique
print('-- checking for unique segments')
t = time.time()
print(list(genomes.keys())[0:5])
print(genInfoDF.shape)
print(uniqSegInfoDF.shape)
elapsed = time.time() - t
print('---- time elapsed:', round(elapsed/60, 2), "min")

# appending num_uniq_segs column to genInfoDF
print('-- appending num_uniq_segs column to genInfoDF')
t = time.time()

genome_IDs = list(genomes.keys())
uniqSeg_IDs = uniqSegInfoDF.index.values
num_uniq_segs = []
for g, genome in enumerate(genome_IDs):
    if g % 100 == 0:
        print('--- on genome number: ', str(g)) # check at every 1000 iterations
    current_segs = set(genomes[genome_IDs[g]])
    current_segs = [s[:-1] for s in current_segs]
    current_segs = set(current_segs)
    # now I have a list of segments for genome1 and I want to see 
    # which of them are contained in the uniq_segments list
    current_num_uniq_segs = len(current_segs.intersection(uniqSeg_IDs))
    num_uniq_segs.append(current_num_uniq_segs)
genInfoDF["num_uniq_segs"] = num_uniq_segs # setting new column in dataframe
elapsed = time.time() - t
print('---- time elapsed:', round(elapsed/60, 2), "min")

genInfoOUT = open(path2genInfoDF, 'wb')
pickle.dump(genInfoDF, genInfoOUT)
genInfoOUT.close()