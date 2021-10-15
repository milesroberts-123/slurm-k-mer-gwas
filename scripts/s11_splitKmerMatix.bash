#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=16G
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

echo Calculating total number of lines in full kmer matrix...
n=$(wc -l allKmersMergedUnique.txt | cut -f 1 -d ' ')
d=500
q=$(( n / d ))

#use suffic length 4 to make renaming easier, which makes each split easy to call in a job array
echo Splitting the full kmer matrix with $n lines into $d submatrices with at most $q lines, plus remainder...
split --numeric-suffixes --suffix-length=4 -l $q allKmersMergedUnique.txt allKmersMergedUnique_split

echo renaming split files...
rename -n 's/split0{1,3}/split/' arabidopsis_wgs_accessions_split*
rename 's/split0{1,3}/split/' arabidopsis_wgs_accessions_split*

