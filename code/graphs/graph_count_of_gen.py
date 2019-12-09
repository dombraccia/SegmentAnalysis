import json
import numpy as np
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt

with open('/cbcbhomes/dfirer/dicts/dict_count_of_gen_per_seg.txt') as json_file:
    data = json.load(json_file)

plt.bar(range(len(data)), list(data.values()), align='center')
plt.xticks(range(len(data)), list(data.keys()))
plt.savefig("/cbcbhomes/dfirer/count_of_gen.png")