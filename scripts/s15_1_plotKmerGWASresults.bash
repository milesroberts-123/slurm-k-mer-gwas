#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=25
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=1G
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

#Load R
ml -* GCC/8.3.0 OpenMPI/3.1.4 R/4.0.2

#Execute R-script
Rscript s25_0_plotKmerGWASresults.R ./output/mvKmerGWASresults_FT16_RGR.assoc.txt mvKmerGWAS $SLURM_CPUS_PER_TASK 0.05
Rscript s25_0_plotKmerGWASresults.R ./output/uvKmerGWASresults_normalized_FT16.assoc.txt uvKmerGWAS_FT16 $SLURM_CPUS_PER_TASK 0.05
Rscript s25_0_plotKmerGWASresults.R ./output/uvKmerGWASresults_normalized_RGR.assoc.txt uvKmerGWAS_RGR $SLURM_CPUS_PER_TASK 0.05
