#!/bin/bash

source samtools-1.9

bam=$1

#echo "Chr1 $(samtools view $bam Chr1 | wc -l) "
#echo "Chr2 $(samtools view $bam Chr2 | wc -l) "
#echo "Chr3 $(samtools view $bam Chr3 | wc -l) "
#echo "Chr4 $(samtools view $bam Chr4 | wc -l) "
#echo "Chr5 $(samtools view $bam Chr5 | wc -l) "
#echo "mitochondria $(samtools view $bam mitochondria | wc -l) "
#echo "chloroplast $(samtools view $bam chloroplast | wc -l) "

samtools idxstats $bam | awk '{print $1, $3}' | grep -v "^*"
