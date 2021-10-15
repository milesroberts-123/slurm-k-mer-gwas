#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=12
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=1G
#SBATCH --array=0-11
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

#Load modules
ml -* GCC/8.2.0-2.31.1 OpenMPI/3.1.3 BLAST+/2.9.0

#BLAST longest scaffold against reference database
while read -u 3 -r KMER; do
	echo Filtering out short scaffolds...
	./seqkit head -n 1 ./assembly_$KMER/spades_output_$KMER/scaffolds.fasta > highConfidenceScaffold_$KMER.fasta
	echo Performing BLAST search...
	blastn -query highConfidenceScaffold_$KMER.fasta -db GCF_000001735.4_TAIR10.1_genomic -num_threads $SLURM_CPUS_PER_TASK -evalue 1e-60 -outfmt 6 -max_hsps 1 -perc_identity 95 -qcov_hsp_perc 95 -out $(echo $KMER)_scaffolds_to_tair10.blast
done 3<mvAnduvKmerGWASsigKmers_split$SLURM_ARRAY_TASK_ID
