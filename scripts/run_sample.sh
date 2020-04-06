#!/bin/bash

source bowtie2-2.3.5
source samtools-1.9

for R1 in /hpc-home/dingp/ATACseq_2019_trial_SH_PD/*R1.fastq.gz ; do R2=$(echo $R1 | sed 's/.R1./.R2./'); sample=$(basename  $R1 | sed 's/[.]/ /g' | awk '{print $1}'); sbatch --mem 30g --cpus 2 -J $sample -o ${sample}.log --wrap " bowtie2 --threads 4 -x /tsl/data/sequences/plants/arabidopsis/tair10/genome/Arabidopsis_thaliana.TAIR10.dna.toplevel --rg-id $sample --no-unal -1 $R1 -2 $R2 | samtools view -b | samtools sort -o /tsl/scratch/shrestha/pingtao/ATACseq_2019_trial_SH_PD/results/bowtie2/${sample}_sorted.bam "; done
