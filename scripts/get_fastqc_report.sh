#!/bin/bash

fastqc_dir=$1
echo sample filename #reads BasicQCStats
for txt in `find $fastqc_dir -type f -name fastqc_data.txt `; do
	echo $(echo $txt | awk -F "/" '{print $(NF-2)}') $(grep Filename $txt | cut -f2) $(grep "Total Sequences" $txt | awk '{print $3}')  $(grep Basic $txt | cut -f2) ;
done | sort
