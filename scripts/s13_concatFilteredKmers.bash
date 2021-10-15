#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=32G
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

#Merge results from first round of filtering
echo These are the files that will be merged
ls -hov allKmersMergedUniqueMAFfilt_split_*.bimbam

#Merge filtered files
echo Merging filtered files...
cat allKmersMergedUniqueMAFfilt_split_*.bimbam > allKmersMergedUniqueMAFfiltCat.bimbam

echo Counting final number of kmers...
wc -l allKmersMergedUniqueMAFfiltCat.bimbam

#Subset k-mers for kinship matrix estimation
echo Randomly sampling k-mers for kinship matrix estimation...
shuf -n 10000000 allKmersMergedUniqueMAFfiltCat.bimbam > allKmersMergedUniqueMAFfiltCatSub.bimbam

#Compress k-mer matrices
gzip allKmersMergedUniqueMAFfiltCatSub.bimbam
gzip allKmersMergedUniqueMAFfiltCat.bimbam

