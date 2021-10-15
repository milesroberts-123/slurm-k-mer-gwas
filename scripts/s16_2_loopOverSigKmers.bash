#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=16G
#SBATCH --array=0-10
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

while read -u 3 -r KMER; do
	#There's only one k-mer presence/absence pattern, so stop reading file after finding one match
	echo Extracting presence/absence pattern for $KMER...
	PATTERN=$(zgrep -m 1 "$KMER" allKmersMergedUniqueMAFfiltCat.bimbam.gz | cut -f 1,2,3 --complement --delimiter="," | sed 's/,/ /g')
  #Extract the accessions with this k-mer present
  echo Extracting accessions where $KMER is present...
  paste --delimiters=' ' kmerFilesList.txt <(echo "$PATTERN" | tr " " "\n") | awk '(($2 == 1))' | cut -f 1 --delimiter=" " | sed 's/_kmers.txt//g' > accessionsWithKmer_$KMER.txt
	#Extract k-mers with matching presence/absence patterns
	echo Searching for other k-mers with this presence/absence pattern: $PATTERN...
	grep "$PATTERN" allKmersMerged.txt | cut -f 1 --delimiter=" " > kmersWithMatchingPresencePatterns_$KMER.txt
done 3<mvAnduvKmerGWASsigKmers_split$SLURM_ARRAY_TASK_ID
