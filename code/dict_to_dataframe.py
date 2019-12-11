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
print('-- converting dictionary to pandas.DataFrame')
segInfoDF = pd.DataFrame.from_dict(segment_info, orient="index")
segInfoDF.columns = ["num_of_genomes", "length_(bp)", "GC_content_(%)"]
testInfoDF = segInfoDF[:100] # grabbing a subset of the data for testing plots
genInfoDF = pd.DataFrame.from_dict(genome_info, orient="index")
genInfoDF.columns = ["num_of_segments"]

# pickling the dataframe
outfile1 = open('../results/segInfoDF.pickle', 'wb')
pickle.dump(segInfoDF, outfile1)
outfile1.close()
outfile2 = open('../results/testInfoDF.pickle', 'wb')
pickle.dump(testInfoDF, outfile2)
outfile2.close()
outfile3 = open('../results/genInfoDF.pickle', 'wb')
pickle.dump(genInfoDF, outfile3)
outfile3.close()
