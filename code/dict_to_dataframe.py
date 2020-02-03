import json
import pandas as pd
import pickle
import sys

'''
A script for converting the .json dictionaries into a pandas DataFrame and 
then subsequently storing that as a pickle to save time loading data in the
plotting step
'''

# open up files
print('-- opening up .json files containing dictionaries')
with open(sys.argv[1]) as seg_info:
    segment_info = json.load(seg_info)
with open(sys.argv[2]) as gen_info:
    genome_info = json.load(gen_info)

# converting dictonary to pandas dataframe
# on segments
print('-- converting dictionary to pandas.DataFrame')
segInfoDF = pd.DataFrame.from_dict(segment_info, orient="index")
segInfoDF.columns = ["num_of_genomes", "length_bp", "GC_content_(%)"]
#testInfoDF = segInfoDF[:100] # grabbing a subset of the data for testing plots
#uniqSegInfoDF = segInfoDF[segInfoDF.num_of_genomes == 1]
genInfoDF = pd.DataFrame.from_dict(genome_info, orient="index")
genInfoDF.columns = ["num_of_segments"]

# pickling the dataframe
segInfoOUT = open(sys.argv[3], 'wb')
pickle.dump(segInfoDF, segInfoOUT)
segInfoOUT.close()
#uniqSegInfoOUT = open('../results/uniqSegInfoDF.pickle', 'wb')
#pickle.dump(uniqSegInfoDF, uniqSegInfoOUT)
#uniqSegInfoOUT.close() # Not sure that I need this right now (17Jan2020)
#testInfoOUT = open('../results/testInfoDF.pickle', 'wb')
#pickle.dump(testInfoDF, testInfoOUT)
#testInfoOUT.close()
genInfoOUT = open(sys.argv[4], 'wb')
pickle.dump(genInfoDF, genInfoOUT)
genInfoOUT.close()
