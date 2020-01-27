## Introduction

This is a snakemake workflow for the analysis of ATACseq data for publication

## Pre-requisites

1) snakemake v5.9+
2) python v3.6+
3) fastqc v0.11+
4) picard v2.18.11

## How to run 

Run the command below in interactive mode

```
snakemake -s scripts/analysis.snakemake -p  --jobs 10 --cluster 'sbatch --cpus 1 --mem 12G' --latency-wait 60  run_fastqc run_duplication
```

The command can also be sbatched to the slurm cluster.
