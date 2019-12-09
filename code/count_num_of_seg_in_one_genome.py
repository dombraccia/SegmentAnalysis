import json
with open('/cbcbhomes/dfirer/dicts/dict_seg_to_gen.txt') as json_file:
    data = json.load(json_file)
count= 0
for seg in data.values():
    num= len(seg)
    if num == 1:
        count+= 1
print(count)        