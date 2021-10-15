#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=100
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=4G
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

#Count kmers before sorting
echo There were this many kmers before filtering
wc -l allKmersMerged.txt

#perform sort
echo Sorting...
sort --parallel=$SLURM_CPUS_PER_TASK -S 80% -k2 -u allKmersMerged.txt > allKmersMergedUnique.txt

#Count kmers after sorting
echo This many kmers remain after filtering
wc -l allKmersMergedUnique.txt
