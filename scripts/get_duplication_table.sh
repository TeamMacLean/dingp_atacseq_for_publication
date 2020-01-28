#!/bin/bash

cd $1
echo Sample dup_perc 
for metric in *_dupmetrics.txt; do
	echo $metric $( grep -A1 LIBRARY  $metric | tail -n 1 | awk -F "\t" '{print $9}' ); 
done | sed 's/_dupmetrics.txt//'
