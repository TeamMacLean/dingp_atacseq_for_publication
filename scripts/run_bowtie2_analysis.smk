#!/usr/bin/env snakemake

configfile: "config.yaml"
projectdir = "/tsl/scratch/shrestha/pingtao/ATACseq_2019_trial_SH_PD/"
print(config['sample'])
reference = "/tsl/data/sequences/plants/arabidopsis/tair10/genome/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"

rule index:
    input: reference
    output: expand([reference + ".1.bt2", reference + ".2.bt2", reference + ".3.bt2", reference + ".4.bt2", reference + ".rev.1.bt2", reference + ".rev.2.bt2"], reference=reference)
    shell: "bowtie2-build -f {reference} {reference}"


rule align_with_bowtie2:
    input:
        R1=lambda wildcards: config['sample'][wildcards.sample]['R1'],
        R2=lambda wildcards: config['sample'][wildcards.sample]['R2'],
        index=expand([reference + ".1.bt2", reference + ".2.bt2", reference + ".3.bt2", reference + ".4.bt2", reference + ".rev.1.bt2", reference + ".rev.2.bt2"], reference=reference)

    output: projectdir + "results/bowtie2/{sample}_sorted.bam"
    message: "Bowtie2 aligning of sample {wildcards.sample}"
    shell: "bowtie2 --threads 4 -x {reference} --rg-id {wildcards.sample} --no-unal -1 {input.R1} -2 {input.R2} | samtools view -b | samtools sort -o {output}"


rule run_bowtie2:
    input: expand([projectdir + "results/bowtie2/{sample}_sorted.bam"], sample=config['sample'].keys() )