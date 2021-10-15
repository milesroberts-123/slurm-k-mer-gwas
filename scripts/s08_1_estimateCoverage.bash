#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=50
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=500M
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

#Estimate coverage
./seqkit stats -j $SLURM_CPUS_PER_TASK *trim.fastq.gz -T > trimmedFastqStats.txt
