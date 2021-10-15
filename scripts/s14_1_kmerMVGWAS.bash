#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=200G
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

#Load required dependencies for gemma if you don't want to use the binary
#ml -* foss/2018b Eigen/3.3.4 GSL/2.5 zlib/1.2.11

#mvGWAS with kmer count covariate
./gemma-0.98.5-linux-static-AMD64 -g allKmersMergedUniqueMAFfiltCat.bimbam.gz -p ./output/pheno_kmerGWAS_FT16_RGR_normalized_imputed.prdt.txt -c kmerCountCovariate.txt -k ./output/kinshipMatrix_FT16_RGR_normalized_kmers.cXX.txt -notsnp -lmm 1 -n 1 2 -o mvKmerGWASresults_FT16_RGR
