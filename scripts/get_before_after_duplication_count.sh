#!/bin/bash
echo Name TotalPE ChrPE ChrMPE ChrCPE Dup%Chr Dup%ChrM Dup%ChrC NoDupTotalPE NoDup%Chr NoDup%ChrM NoDup%ChrC RmDup%Chr RmDup%ChrM RmDup%ChrC | sed 's/ /,/g'
for bam in  /tsl/scratch/shrestha/pingtao/dingp_Ath_ATACseq_2019_1/wt*_sorted.bam /tsl/scratch/shrestha/pingtao/dingp_Ath_ATACseq_2019_1/seti[^gh]*_sorted.bam   ; do
    mappedtotal=$(cat ${bam}.chr.count.txt | awk 'BEGIN{sum=0}{sum+=$2}END{print sum/2}');
    nobam=$(echo $bam | sed 's/.bam$//');
    base=$(basename $bam | sed 's/_sorted.bam//;s/_/ /g' | awk 'BEGIN{OFS="_"}{$NF="";  print $0}' | sed 's/_$//');
    total=$(grep ^Total /tsl/scratch/shrestha/pingtao/dingp_Ath_ATACseq_2019_1/results/fastqc/$base/$base/*R1_fastqc/fastqc_data.txt | awk '{print $3}');

    chromosome=$(grep -A1 ^LIBRARY ${nobam}_chr1_5_picard_markdup_stats.txt | tail -n 1 | awk -F "\t" '{print $3}');
    mitochondria=$(grep -A1 ^LIBRARY ${nobam}_mitochondria_picard_markdup_stats.txt | tail -n 1 | awk  -F "\t" '{print $3}');
    chloroplast=$(grep -A1 ^LIBRARY ${nobam}_chloroplast_picard_markdup_stats.txt | tail -n 1 | awk  -F "\t" '{print $3}');

    chromosomeDupPerc=$(grep -A1 ^LIBRARY ${nobam}_chr1_5_picard_markdup_stats.txt | tail -n 1 | awk  -F "\t" '{print $9 * 100}');
    mitochondriaDupPerc=$(grep -A1 ^LIBRARY ${nobam}_mitochondria_picard_markdup_stats.txt | tail -n 1 | awk  -F "\t" '{print $9 * 100}');
    chloroplastDupPerc=$(grep -A1 ^LIBRARY ${nobam}_chloroplast_picard_markdup_stats.txt | tail -n 1 | awk  -F "\t" '{print $9 * 100}');
    
    chromosomePerc=$(grep -A1 ^LIBRARY ${nobam}_chr1_5_picard_markdup_stats.txt | tail -n 1 | awk -v mappedtotal=$mappedtotal -F "\t" '{print ($3/mappedtotal)*100}');
    mitochondriaPerc=$(grep -A1 ^LIBRARY ${nobam}_mitochondria_picard_markdup_stats.txt | tail -n 1 | awk -v mappedtotal=$mappedtotal -F "\t" '{print ($3/mappedtotal)*100}');
    chloroplastPerc=$(grep -A1 ^LIBRARY ${nobam}_chloroplast_picard_markdup_stats.txt | tail -n 1 | awk -v mappedtotal=$mappedtotal -F "\t" '{print ($3/mappedtotal)*100}');

    totalNoDups=$(cat ${nobam}*_nodups_counts.txt | awk 'BEGIN{sum=0}{sum+=$1}END{print sum/2}')  # divide by 2 for Paired end
    chromosomeNoDups=$(cat ${nobam}_chr1_5_nodups_counts.txt | awk -v totalNoDups=$totalNoDups '{pe=$1/2; print (pe/totalNoDups)*100 }')
    mitochondriaNoDups=$(cat ${nobam}_mitochondria_nodups_counts.txt | awk -v totalNoDups=$totalNoDups '{pe=$1/2; print (pe/totalNoDups)*100}')
    chloroplastNoDups=$(cat ${nobam}_chloroplast_nodups_counts.txt | awk -v totalNoDups=$totalNoDups '{pe=$1/2; print (pe/totalNoDups)*100}')

    chromosomeNoDupsRemain=$(cat ${nobam}_chr1_5_nodups_counts.txt | awk -v mappedtotal=$chromosome '{pe=$1/2; print (pe/mappedtotal)*100 }')
    mitochondriaNoDupsRemain=$(cat ${nobam}_mitochondria_nodups_counts.txt | awk -v mappedtotal=$mitochondria '{pe=$1/2; print (pe/mappedtotal)*100}')
    chloroplastNoDupsRemain=$(cat ${nobam}_chloroplast_nodups_counts.txt | awk -v mappedtotal=$chloroplast '{pe=$1/2; print (pe/mappedtotal)*100}')



    echo  $base $total $chromosomePerc $mitochondriaPerc $chloroplastPerc $chromosomeDupPerc $mitochondriaDupPerc $chloroplastDupPerc $totalNoDups $chromosomeNoDups $mitochondriaNoDups $chloroplastNoDups $chromosomeNoDupsRemain $mitochondriaNoDupsRemain $chloroplastNoDupsRemain | sed 's/ /,/g'




done