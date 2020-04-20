#!/bin/bash

# getting percentage of reads aligned to chromosomes, mitochondria, chloroplast

echo "Sample,TotalPESeqs,Chr1-5,mitochondria,chloroplast" > analysis/percent_aligned_by_chromosome.csv; 
for bam in  /tsl/scratch/shrestha/pingtao/dingp_Ath_ATACseq_2019_1/wt*_sorted.bam /tsl/scratch/shrestha/pingtao/dingp_Ath_ATACseq_2019_1/seti[^gh]*_sorted.bam   ; do
	base=$(basename $bam | sed 's/_sorted.bam//;s/_/ /g' | awk 'BEGIN{OFS="_"}{$NF="";  print $0}' | sed 's/_$//');
	total=$(grep ^Total /tsl/scratch/shrestha/pingtao/dingp_Ath_ATACseq_2019_1/results/fastqc/$base/$base/*R1_fastqc/fastqc_data.txt | awk '{print $3}'); 
	chr1_5_pe=$(cat ${bam}.chr.count.txt | grep ^Chr | awk -v total=$total 'BEGIN{sum=0}{sum+=$2}END{print ((sum/2)/total)*100}')  # dividing by 2 to get total paired end reads
	mitochondria=$(cat ${bam}.chr.count.txt | grep mitochondria | awk -v total=$total '{print (($2/2)/total)*100}')  # dividing to get paired end reads
	chloroplast=$(cat ${bam}.chr.count.txt | grep chloroplast | awk -v total=$total '{print (($2/2)/total)*100}')   # dividing to get paired end reads
	echo $base,$total,${chr1_5_pe},$mitochondria,$chloroplast ;
done  >> analysis/percent_aligned_by_chromosome.csv
