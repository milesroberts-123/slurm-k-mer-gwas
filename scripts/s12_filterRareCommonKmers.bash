#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=1G
#SBATCH --array=0-500
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

#Load python for doing minor allele frequency calculations
ml -* GCCcore/8.3.0 Python/3.8.3

#Specify input file
INPUT="allKmersMergedUnique_split$SLURM_ARRAY_TASK_ID"

#Count columns and determine cross-accession frequency cutoffs
#With these cutoffs, a k-mer cannot be present in more than 95 % or fewer than 5 % of accessions in order to be included in GWAS
ncol=$(head -n 1 $INPUT | grep -o " " | wc -l)
echo The number of columns is $ncol
upr=$(python3 -c "from math import ceil; print(ceil($ncol*0.95))")
echo The upper bound for frequency is $upr
lwr=$(python3 -c "from math import floor; print(floor($ncol*0.05))")
echo The lower bound for frequency is $lwr

#Filter out common and rare kmers
echo Exclude rare and common kmers...
#Create empty file for results
rm allKmersMergedUniqueMAFfilt_split_$(echo $SLURM_ARRAY_TASK_ID).bimbam
#Check if each k-mer meets frequency criteria, if so then convert it to bimbam format, which is needed for GEMMA later
while read -u 3 -r LINE; do
        #Count number of accessions that have a particular kmer
        n=$(echo $LINE | cut -f1 --complement |awk '{sum=0; for(i=1; i<=NF; i++) sum += $i; print sum}')
        #Check count against thresholds for rarity and commonality
        if [ $n -gt $lwr ] && [ $n -lt $upr ]
        then
	#If kmer is neither rare nor common, keep it and format it's line like a bimbam file
                echo $LINE | sed 's/ / X Y /' | sed 's/ /,/g' >> allKmersMergedUniqueMAFfilt_split_$(echo $SLURM_ARRAY_TASK_ID).bimbam
        fi
done 3<$INPUT

