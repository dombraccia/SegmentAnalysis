f_out= open("plines.txt","w")

with open('scg_segments_k99.gfa1') as segk99:
    for line in segk99:
        if line[0] == 'P':
            f_out.write("%s \n" %line)
f_out.close()
segk99.close()