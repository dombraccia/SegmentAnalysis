import json
seg={}
with open('/fs/cbcb-scratch/dfirer/data/data/plines.txt') as plines:
    #r= plines.readline().split()
    for line in plines:
        if line[0] == 'P':
            line= line.split()
            segs= line[2].split(',')
            for each_seg in segs:
                if each_seg[:-1] in seg.keys():
                    if each_seg[-1] == '+':
                        seg[each_seg[:-1]][0] += 1
                    else:
                        seg[each_seg[:-1]][1] += 1
                else:
                    if each_seg[-1] == '+':
                        seg[each_seg[:-1]]= [1, 0]
                    else:
                        seg[each_seg[:-1]] = [0,1]
plines.close()

with open('dict_seg_to_plusminus.txt', 'w') as output:
    json.dump(seg, output)
