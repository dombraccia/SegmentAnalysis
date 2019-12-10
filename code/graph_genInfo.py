import json
import pandas as pd
import numpy as np
import seaborn as sns
import vaex
import pickle
import time

'''
A script for graphing histograms from genome_info.json dictionaries
'''

# open up files from pickle
print('-- loading dataframe of genInfo ')
t = time.time()
genInfoDF = pickle.load(open("../results/genInfoDF.pickle", "rb"))
testInfo = genInfoDF[:100]
elapsed = time.time() - t
print("--- time elapsed: ", round(elapsed/60, 2), "min")

# ======================= BASIC HISTOGRAM PLOTS ============================= #

print('-- histogram of num_of_segments using vaex')
t = time.time()
genInfoVX = vaex.from_pandas(genInfoDF)
plt = genInfoVX.plot1d(genInfoVX.num_of_segments)
plt.savefig('../results/log_numOfSegments_hist.png')
elapsed = time.time() - t
print("--- time elapsed: ", round(elapsed/60, 2), "min")
