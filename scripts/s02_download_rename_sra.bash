#!/bin/bash
echo "USAGE: ./download_rename_sra.bash -s <LIST OF SRA NUMBERS> -n <LIST OF NEW NAMES FOR SRA FILES>"
#Parse input arguments
while getopts s:n: option; do
		case "${option}" in
			s) SRAS=${OPTARG};;
			n) NAMES=${OPTARG};;
		esac
	done

#Download and rename SRA data
while read -u 3 -r SRA && read -u 4 -r NAME; do
	echo Downloading $SRA and renaming it to $NAME

	#Download data
	fastq-dump --split-e $SRA
	#fastq-dump $SRA

	#Rename data
	#If data is accidentially labeled as paired, rename the single-end file too
	mv $(echo $SRA)_1.fastq $(echo $NAME)_1.fastq
	mv $(echo $SRA)_2.fastq $(echo $NAME)_2.fastq
	mv $(echo $SRA).fastq $(echo $NAME).fastq

	#Compress data
	gzip $(echo $NAME)_1.fastq
	gzip $(echo $NAME)_2.fastq
	gzip $(echo $NAME).fastq
done 3<$SRAS 4<$NAMES

