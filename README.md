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

To run ATACcapseq data - dingp_ath_mutants_fansataccapseq_20170630_nextseq500_pe_midoutput

```
bash scripts/run_fastqc_bowtie2.sh
```

The command can also be sbatched to the slurm cluster.

## Analysis tables

The number of reads aligned to a chromosome is obtained using scripts/get_total_mapped_by_chromosome.sh. As the reads are paired end, the reads from R1 and R2 are considered together, therefore, we see twice the number reads.

The percentage of reads aligned to a particular chromosome is obtained using scripts/get_percent_mapped_by_chromosome.sh. As the data is paired end, reads from both R1 and R2 are considered, so to get the right percentage, I have divided by 2.

The fastqc report and picard duplication table were obtained using scripts/analysis.snakemake. See above section How to run.
