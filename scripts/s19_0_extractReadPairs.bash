#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=300G
#SBATCH --array=0-11
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

#Assemble reads containing significant kmers, seperate out accessions with paired vs unpaired reads
while read -u 3 -r KMER; do
	
	cd assembly_$KMER
	rm readsFromAllAcc*.fastq
	echo Compile all filtered reads containing $KMER from these files
	ls *filt.fastq
	cat *filt.fastq > readsFromAllAcc_$(echo $KMER)_filtNoPairingAttempt.fastq

	while read -u 3 -r SRA; do
		echo Pairing reads for sample $SRA that contain $KMER...
		if test -f $(echo $SRA)_1_trim_filt.fastq; then
			#sort trimmed reads so that seqkit doesn't take up massive amounts of memory
			#Probably doesn't help much but whatever...
			../seqkit sort -n $(echo $SRA)_1_trim_filt.fastq > $(echo $SRA)_1_trim_filt_sorted.fastq
			../seqkit sort -n $(echo $SRA)_2_trim_filt.fastq > $(echo $SRA)_2_trim_filt_sorted.fastq
      			#Find read partners in trimmed data
			../seqkit pair -1 $(echo $SRA)_1_trim_filt_sorted.fastq -2 ../$(echo $SRA)_2_trim.fastq.gz
			../seqkit pair -1 $(echo $SRA)_2_trim_filt_sorted.fastq -2 ../$(echo $SRA)_1_trim.fastq.gz
			#Merge together paired reads
			#If there were paired reads in filt fastq files, you'll have duplicates at this step unless you remove them
			zcat $(echo $SRA)_1_trim.paired.fastq.gz | cat $(echo $SRA)_1_trim_filt_sorted.paired.fastq - | ../seqkit rmdup -n | ../seqkit sort -n > $(echo $SRA)_1_trim_filt.AllPaired.fastq
			zcat $(echo $SRA)_2_trim.paired.fastq.gz | cat $(echo $SRA)_2_trim_filt_sorted.paired.fastq - | ../seqkit rmdup -n | ../seqkit sort -n > $(echo $SRA)_2_trim_filt.AllPaired.fastq
			#Concatenate reads with growing file of reads from all accessions
			cat $(echo $SRA)_1_trim_filt.AllPaired.fastq >> readsFromAllAcc_$(echo $KMER)_1.fastq
			cat $(echo $SRA)_2_trim_filt.AllPaired.fastq >> readsFromAllAcc_$(echo $KMER)_2.fastq
		else
			#Just do this if data is single end
			cat $(echo $SRA)_trim_filt.fastq >> readsFromAllAcc_$(echo $KMER)_unpaired.fastq
		fi
	done 3<../accessionsWithKmer_$KMER.txt

	#Move up a file level to access next k-mer directory
	cd ..
done 3<mvAnduvKmerGWASsigKmers_split$SLURM_ARRAY_TASK_ID
