#!/bin/bash

source bowtie2-2.3.5
source samtools-1.9

datafolder=/tsl/data/reads/jjones/dingp_ath_mutants_fansataccapseq_20170630_nextseq500_pe_midoutput
workdir=/hpc-home/shrestha/workarea/pingtao/dingp_ath_mutants_fansataccapseq_20170630_nextseq500_pe_midoutput
projectdir=/tsl/scratch/shrestha/pingtao/dingp_ath_mutants_fansataccapseq_20170630_nextseq500_pe_midoutput

# go to workdir
cd $workdir

# create output dir
outdir=${projectdir}/results/bowtie2
fastqcdir=${projectdir}/results/fastqc

mkdir -p $outdir $fastqcdir

logdir=${projectdir}/logs
mkdir -p ${projectdir}/logs

# reference sequence
reference=/tsl/data/sequences/plants/arabidopsis/tair10/genome/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa


#run fastqc

for dir in /tsl/data/reads/jjones/dingp_ath_mutants_fansataccapseq_20170630_nextseq500_pe_midoutput/*/*capture_*/raw; do
	sample=$(echo $dir | sed 's%/% %g' | awk '{print $(NF-2)}');
	for fastq in ${dir}/*.fastq.gz; do
		fastqbasename=$(basename $fastq | sed 's/.fastq.gz$//')
		if [ ! -e ${fastqcdir}/${fastqbasename}_fastqc/fastqc_data.txt ]; then
		sbatch --mem 10g -o ${logdir}/${sample}_fastqc.log  -J ${sample}_fastqc --wrap "fastqc --extract --outdir /tsl/scratch/shrestha/pingtao/dingp_ath_mutants_fansataccapseq_20170630_nextseq500_pe_midoutput/results/fastqc $fastq "
		else
			echo $sample $fastqbasename FASTQC already completed
		fi
	done
done
for dir in /tsl/data/reads/jjones/dingp_ath_mutants_fansataccapseq_20170630_nextseq500_pe_midoutput/*/*capture_*/raw; do
	sample=$(echo $dir | sed 's%/% %g' | awk '{print $(NF-2)}');
	if [ ! -e "${outdir}/${sample}_sorted.bam" ]; then
	sbatch --mem 30g -o ${logdir}/${sample}_bowtie2.log -J ${sample} --cpus 2 --wrap "bowtie2 --threads 4 -x ${reference} --rg-id ${sample} --no-unal -1 $(echo ${dir}/*_R1_001.fastq.gz | sed 's/ /,/g') -2 $(echo ${dir}/*_R2_001.fastq.gz | sed 's/ /,/g') | samtools view -b | samtools sort -o ${outdir}/${sample}_sorted.bam && samtools index ${outdir}/${sample}_sorted.bam ";
	sleep 2
	else
	echo $sample alignment already completed
	fi
done
