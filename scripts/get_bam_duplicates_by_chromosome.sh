#!/bin/bash

source samtools-1.9
bam=$1
out=$(echo $bam | sed 's/.bam$//')

samtools view -H $bam > ${out}_chr1_5.sam;
samtools view -H $bam > ${out}_mitochondria.sam;
samtools view -H $bam > ${out}_chloroplast.sam;

samtools view $bam Chr1 >> ${out}_chr1_5.sam
samtools view $bam Chr2 >> ${out}_chr1_5.sam
samtools view $bam Chr3 >> ${out}_chr1_5.sam
samtools view $bam Chr4 >> ${out}_chr1_5.sam
samtools view $bam Chr5 >> ${out}_chr1_5.sam
samtools view $bam mitochondria >> ${out}_mitochondria.sam
samtools view $bam chloroplast >> ${out}_chloroplast.sam

samtools view -b -o ${out}_chr1_5.bam ${out}_chr1_5.sam && rm ${out}_chr1_5.sam
samtools view -b -o ${out}_mitochondria.bam ${out}_mitochondria.sam && rm ${out}_mitochondria.sam 
samtools view -b -o ${out}_chloroplast.bam ${out}_chloroplast.sam && rm ${out}_chloroplast.sam

source picard-2.18.11
picard MarkDuplicates REMOVE_SEQUENCING_DUPLICATES=true REMOVE_DUPLICATES=true INPUT=${out}_chr1_5.bam  OUTPUT=${out}_chr1_5_nodups.bam  METRICS_FILE=${out}_chr1_5_picard_markdup_stats.txt && samtools view ${out}_chr1_5_nodups.bam | wc -l > ${out}_chr1_5_nodups_counts.txt && rm ${out}_chr1_5.bam ${out}_chr1_5_nodups.bam

picard MarkDuplicates REMOVE_SEQUENCING_DUPLICATES=true REMOVE_DUPLICATES=true INPUT=${out}_mitochondria.bam  OUTPUT=${out}_mitochondria_nodups.bam  METRICS_FILE=${out}_mitochondria_picard_markdup_stats.txt && samtools view ${out}_mitochondria_nodups.bam | wc -l > ${out}_mitochondria_nodups_counts.txt && rm ${out}_mitochondria.bam ${out}_mitochondria_nodups.bam

picard MarkDuplicates REMOVE_SEQUENCING_DUPLICATES=true REMOVE_DUPLICATES=true INPUT=${out}_chloroplast.bam  OUTPUT=${out}_chloroplast_nodups.bam  METRICS_FILE=${out}_chloroplast_picard_markdup_stats.txt && samtools view ${out}_chloroplast_nodups.bam | wc -l > ${out}_chloroplast_nodups_counts.txt && rm ${out}_chloroplast.bam ${out}_chloroplast_nodups.bam
