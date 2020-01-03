# ============================ INITIALIZE LISTS ============================= #
# Would be useful to list out all different subsets of genomes I would like to
# run this analysis on like list = ["subset_complete_genome", "subset_Strep", ...]

# =============================== MAKE RULES ================================ #

rule download_genomes:
    output:
        "data/all_complete_refseq_bac_oneline.fasta"
    shell:
        "time bash code/download_refseq_genomes.sh"

rule subset_selected_seqs:
    input:
        "data/all_complete_refseq_bac_oneline.fasta"
    output:
        "data/subset_complete_genome.fasta", 
        "data/subset_Streptococcus.fasta"
    shell:
        "time bash code/subset_selected_seqs.sh"

rule tpc_gd:
    input:
        "data/subset_complete_genome.fasta",
        "data/subset_Streptococcus.fasta"
    output:
        "data/subset_complete_genome.gfa1",
        "data/subset_Streptococcus.gfa1"
    shell:
        "time bash ./tpc_gd.sh de_Bruijn.bin 99 {input} {output}"
