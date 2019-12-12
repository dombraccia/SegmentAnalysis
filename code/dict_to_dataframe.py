import json
import pandas as pd
import pickle

'''
A script for converting the .json dictionaries into a pandas DataFrame and 
then subsequently storing that as a pickle to save time loading data in the
plotting step
'''

# open up files
print('-- opening up .json files containing dictionaries')
with open('../data/scg_k99_segment_info.json') as seg_info:
    segment_info = json.load(seg_info)
with open('../data/scg_k99_genome_info.json') as gen_info:
    genome_info = json.load(gen_info)

# converting dictonary to pandas dataframe
# on segments
print('-- converting dictionary to pandas.DataFrame')
segInfoDF = pd.DataFrame.from_dict(segment_info, orient="index")
segInfoDF.columns = ["num_of_genomes", "length_bp", "GC_content_(%)"]
testInfoDF = segInfoDF[:100] # grabbing a subset of the data for testing plots
uniqSegInfoDF = segInfoDF[segInfoDF.num_of_genomes == 1]
genInfoDF = pd.DataFrame.from_dict(genome_info, orient="index")
genInfoDF.columns = ["num_of_segments"]

# pickling the dataframe
segInfoOUT = open('../results/segInfoDF.pickle', 'wb')
pickle.dump(segInfoDF, segInfoOUT)
segInfoOUT.close()
uniqSegInfoOUT = open('../results/uniqSegInfoDF.pickle', 'wb')
pickle.dump(uniqSegInfoDF, uniqSegInfoOUT)
uniqSegInfoOUT.close()
testInfoOUT = open('../results/testInfoDF.pickle', 'wb')
pickle.dump(testInfoDF, testInfoOUT)
testInfoOUT.close()
genInfoOUT = open('../results/genInfoDF.pickle', 'wb')
pickle.dump(genInfoDF, genInfoOUT)
genInfoOUT.close()
