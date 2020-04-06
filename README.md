## Introduction

This is a snakemake workflow for the analysis of ATACseq data for publication

## Pre-requisites

1) snakemake v5.9+
2) python v3.6+
3) fastqc v0.11+
4) picard v2.18.11
5) bowtie2 v2.3.5
6) samtools v1.9

## Analysis steps

1) FASTQC 
2) mark duplication of reads in bam files
3) bowtie2 alignment


## How to run 

To run FASTQC duplication analysis, run the command below in interactive mode

```
snakemake -s scripts/analysis.snakemake -p  --jobs 10 --cluster 'sbatch --cpus 1 --mem 12G' --latency-wait 60  run_fastqc run_duplication get_duplication_table
```

To run bowtie2 alignment, run 

```
snakemake -s scripts/run_bowtie2_analysis.smk -p run_bowtie2 --cluster 'sbatch --cpus 2 --mem 30g ' --latency-wait 60 --jobs 4  
```

The command can also be sbatched to the slurm cluster.
