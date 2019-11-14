import json

with open('/cbcbhomes/dfirer/dict_gen_to_seg.txt') as json_file:
    data = json.load(json_file)
counts= {}
for seg in data.values():
    count= len(seg)
    if count in counts.keys():
        counts[count]= counts[count] + 1
    else:
        counts[count]= 1

with open('dict_count_of_seg_per_gen.txt', 'w') as output1:
    json.dump(counts, output1)