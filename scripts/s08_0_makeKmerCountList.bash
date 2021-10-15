#!/bin/bash
#Create list of files to merge
ls *kmers.txt > kmerFilesList.txt

#Split files for parallelization
split --numeric-suffixes -l 25 kmerFilesList.txt kmerFilesListSplit

#Rename files for easy calling in SLURM
rename -v Split0 Split kmerFilesListSplit*

#Count the number of k-mers present in each accession
wc -l *kmers.txt > kmerCounts.txt
