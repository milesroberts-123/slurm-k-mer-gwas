#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=0-11
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

#Load modules
ml -* GCC/10.2.0 SPAdes/3.15.2

#Assemble reads containing significant kmers, seperate out accessions with paired vs unpaired reads
while read -u 3 -r KMER; do

        cd assembly_$KMER
	
	#Create local assembly
	#If there are unpaired reads for a k-mer, then include them in the assembly
	#Else, don't include unpaired reads
	if test -f readsFromAllAcc_$(echo $KMER)_unpaired.fastq; then
		spades.py --careful --only-assembler --pe1-1 readsFromAllAcc_$(echo $KMER)_1.fastq --pe1-2 readsFromAllAcc_$(echo $KMER)_2.fastq --pe1-s readsFromAllAcc_$(echo $KMER)_unpaired.fastq -o spades_output_$(echo $KMER)
	else
		spades.py --careful --only-assembler --pe1-1 readsFromAllAcc_$(echo $KMER)_1.fastq --pe1-2 readsFromAllAcc_$(echo $KMER)_2.fastq -o spades_output_$(echo $KMER)
	fi

	cd ..

done 3<mvAnduvKmerGWASsigKmers_split$SLURM_ARRAY_TASK_ID
