import matplotlib
import numpy as np
import json
import matplotlib.pyplot as plt
import seaborn as sns
sns.set()
with open('/cbcbhomes/dfirer/dicts/dict_seg_to_plusminus.txt') as json_file:
    data = json.load(json_file)

diff= []
for seg in data.values():
    diff.append(seg[0]- seg[1]) # more + will be positive more - will be neg

num_bins= 300
n, bins, patches = plt.hist(diff, num_bins, facecolor='blue', alpha=0.5) 
# plus= []
# minus= []
# for seg in data.values():
#     plus.append(seg[0])
#     minus.append(seg[1])
#DOUBLE BAR GRAPH
# n_groups= len(data)
# fig, ax = plt.subplots()
# index= np.arange(n_groups)
# bar_width = 0.35
# opacity = 0.8
# rects1 = plt.bar(index, plus, bar_width, alpha=opacity, color='b', label='PLUS')
# rects2 = plt.bar(index + bar_width, minus, bar_width, alpha=opacity, color='g', label='MINUS')
plt.xlabel('Difference in Plus vs Minus Counts Per Segment')
plt.ylabel('Count')
plt.title('Plus to Minus Count Per Segment')
#plt.legend()

plt.tight_layout()
plt.savefig("/cbcbhomes/dfirer/plus_vs_minus.png")
