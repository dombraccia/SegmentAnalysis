import json
gen={}
seg={}
with open('/fs/cbcb-scratch/dfirer/data/data/ex_plines.txt') as plines:
    #r= plines.readline().split()
    for line in plines:
        if line[0] == 'P':
            line= line.split()
            segs= line[2].split(',')
            if line[1] in gen.keys():
                gen[line[1]].extend(segs)
            else:    
                gen[line[1]]= segs
            for each_seg in segs:
                if each_seg in seg.keys():
                    seg[each_seg].append(line[1])
                else:
                    seg[each_seg]= [line[1]]

plines.close()

with open('dict_gen_to_seg_ex.txt', 'w') as output1:
    json.dump(gen, output1)
with open('dict_seg_to_gen_ex.txt', 'w') as output2:
    json.dump(seg, output2)    