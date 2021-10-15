#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=16G
#SBATCH --array=0-11
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

while read -u 3 -r KMER; do
	cd assembly_$KMER
	rm -r tmp
	mkdir tmp
	#Create databases of significant kmers
	../kmc -k31 -ci1 ../kmersWithMatchingPresencePatterns_$KMER.fastq sigkmers tmp
	#Filter out reads with significant k-mers
	while read -u 3 -r SRA; do
		echo Filtering out trimmed reads in sample $SRA with k-mer $KMER...
		if [ -f "../$(echo $SRA)_1_trim.fastq.gz" ]; then
			../kmc_tools filter sigkmers -ci1 ../$(echo $SRA)_1_trim.fastq.gz -ci1 $(echo $SRA)_1_trim_filt.fastq
			../kmc_tools filter sigkmers -ci1 ../$(echo $SRA)_2_trim.fastq.gz -ci1 $(echo $SRA)_2_trim_filt.fastq
        	else
        		../kmc_tools filter sigkmers -ci1 ../$(echo $SRA)_trim.fastq.gz -ci1 $(echo $SRA)_trim_filt.fastq
		fi
	done 3<../accessionsWithKmer_$KMER.txt
	cd ..
done 3<mvAnduvKmerGWASsigKmers_split$SLURM_ARRAY_TASK_ID
