import json
import pandas as pd
import pickle
import sys

'''
A script for converting the .json dictionaries into a pandas DataFrame and 
then subsequently storing that as a pickle to save time loading data in the
plotting step
'''
# read in standard input from Snakefile
path2segInfoJson = sys.argv[1]
path2genInfoJson = sys.argv[2]
path2segInfoCSV = sys.argv[3]
path2segInfoDF = sys.argv[4]
path2genInfoDF = sys.argv[5]
path2uniqSegInfoDF = sys.argv[6]

# open up files
print('-- opening up .json files containing dictionaries')
with open(path2segInfoJson) as seg_info:
    segment_info = json.load(seg_info)
with open(path2genInfoJson) as gen_info:
    genome_info = json.load(gen_info)

# converting dictonary to pandas dataframe
# on segments
print('-- converting dictionary to pandas.DataFrame')
segInfoDF = pd.DataFrame.from_dict(segment_info, orient="index")
segInfoDF.columns = ["num_of_genomes", "length_bp", "GC_content_(%)"]
#testInfoDF = segInfoDF[:100] # grabbing a subset of the data for testing plots
uniqSegInfoDF = segInfoDF[segInfoDF.num_of_genomes == 1]
genInfoDF = pd.DataFrame.from_dict(genome_info, orient="index")
genInfoDF.columns = ["num_of_segments"]

# saving DataFrame to csv (for use in R scripts)
print('-- saving DataFrame as csv for R script input')
segInfoDF.to_csv(path2segInfoCSV, index = False)

# pickling the dataframe
segInfoOUT = open(path2segInfoDF, 'wb')
pickle.dump(segInfoDF, segInfoOUT)
segInfoOUT.close()
uniqSegInfoOUT = open(path2uniqSegInfoDF, 'wb')
pickle.dump(uniqSegInfoDF, uniqSegInfoOUT)
uniqSegInfoOUT.close() # Not sure that I need this right now (17Jan2020)
#testInfoOUT = open('../results/testInfoDF.pickle', 'wb')
#pickle.dump(testInfoDF, testInfoOUT)
#testInfoOUT.close()
genInfoOUT = open(path2genInfoDF, 'wb')
pickle.dump(genInfoDF, genInfoOUT)
genInfoOUT.close()
