#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=32
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=500M
#SBATCH --array=0-403
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

#Move to working directory, create temporary folder
rm -r tmp_$SLURM_ARRAY_TASK_ID
mkdir tmp_$SLURM_ARRAY_TASK_ID

#Count kmers in trimmed fastq.gz files
#You want your k-mer length (-k) to be the length of the smallest reads you allowed to keep at the cutadapt step
#-ci and -cs specify that we're only gonna track a k-mer's frequency until it reaches ten (our frequency threshold), then we'll stop counting
while read -u 3 -r SRA; do
	if [ -f "$(echo $SRA)_1_trim.fastq.gz" ]; then
    		#Count kmers for read1 and read2
        	echo Counting kmers for $SRA ...
        	./kmc -k31 -m16 -t$SLURM_CPUS_PER_TASK -ci10 -cs10 $(echo $SRA)_1_trim.fastq.gz temporary1_$SLURM_ARRAY_TASK_ID tmp_$SLURM_ARRAY_TASK_ID
        	./kmc -k31 -m16 -t$SLURM_CPUS_PER_TASK -ci10 -cs10 $(echo $SRA)_2_trim.fastq.gz temporary2_$SLURM_ARRAY_TASK_ID tmp_$SLURM_ARRAY_TASK_ID
        	#Unionize kmer databases
        	echo Merging kmer databases for $SRA
        	./kmc_tools simple temporary1_$SLURM_ARRAY_TASK_ID temporary2_$SLURM_ARRAY_TASK_ID union union_1_2_$SLURM_ARRAY_TASK_ID
        	#No need to sort unionized kmer database, union function gives sorted output
        	#Dump to text file
        	echo Dumping kmers for $SRA to text file...
        	./kmc_tools transform union_1_2_$SLURM_ARRAY_TASK_ID dump $(echo $SRA)_kmers.txt
	else
    		#Count kmers for read1
                echo Counting kmers for $SRA ...
                ./kmc -k31 -m16 -t$SLURM_CPUS_PER_TASK -ci10 -cs10 $(echo $SRA)_trim.fastq.gz temporary1_$SLURM_ARRAY_TASK_ID tmp_$SLURM_ARRAY_TASK_ID
                #Sort kmer database
                echo Sorting kmer database for $SRA
                ./kmc_tools transform temporary1_$SLURM_ARRAY_TASK_ID sort sorted_$SLURM_ARRAY_TASK_ID
                #No need to sort unionized kmer database, union function gives sorted output
                #Dump to text file
                echo Dumping kmers for $SRA to text file...
                ./kmc_tools transform sorted_$SLURM_ARRAY_TASK_ID dump $(echo $SRA)_kmers.txt
	fi
done 3<arabidopsis_wgs_accessions_split$SLURM_ARRAY_TASK_ID
