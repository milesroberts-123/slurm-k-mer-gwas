#!/bin/bash
while read -u 3 -r KMER; do
	echo Creating a directory where the assembly of reads with $KMER will occur...
	rm -r assembly_$KMER
	mkdir assembly_$KMER
done 3<mvAnduvKmerGWASsigKmers.txt
