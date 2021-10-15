#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=3G
#SBATCH --array=0-16
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

#Define recursive join function that works on multiple files
#code from: https://unix.stackexchange.com/questions/364735/merge-multiple-files-with-join
xjoin() {
    local f

    if [ "$#" -lt 2 ]; then
            echo "xjoin: need at least 2 files" >&2
            return 1
    elif [ "$#" -lt 3 ]; then
            join -a 1 -a 2 -e'0' -o auto "$1" "$2"
    else
            f=$1
            shift
            join -a 1 -a 2 -e'0' -o auto "$f" <(xjoin "$@")
    fi
}

#Extract file names for kmer matrix merge, print as space-deliminted list on one line
names=$(cat kmerFilesListSplit$SLURM_ARRAY_TASK_ID | tr -d '\n' | sed 's/txt/txt /g')
echo Merge these files
echo $names

#Perform join on multiple files, convert numbers 10 and higher into 1's to denote kmer presence
xjoin $names | sed -E 's/10|20/1/g' > merged_kmers_$SLURM_ARRAY_TASK_ID.txt

