#!/bin/bash
#Convert k-mer sequences to fastq format because KMC filtering requires it
for FILE in kmersWithMatchingPresencePatterns_*
do
	 awk '{print ">" NR "\n" $s}' $FILE | ./seqtk seq -F 'I' - > $(basename $FILE .txt).fastq
done
