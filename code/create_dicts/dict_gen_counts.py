import json

with open('/cbcbhomes/dfirer/dict_seg_to_gen.txt') as json_file:
    data = json.load(json_file)
counts= {}
for seg in data.values():
    count= len(seg)
    if count in counts.keys():
        counts[count]= counts[count] + 1
    else:
        counts[count]= 1

with open('/cbcbhomes/dfirer/dict_count_of_gen_per_seg.txt', 'w') as output1:
    json.dump(counts, output1)