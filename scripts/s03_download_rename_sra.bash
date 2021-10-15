#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=500M
#SBATCH --array=0-403
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

#Load modules
ml -* SRA-Toolkit/2.10.7-centos_linux64

#Download SRA runs and rename them according to the accession they came from
./s02_download_rename_sra.bash -s arabidopsis_wgs_sras_split$(echo $SLURM_ARRAY_TASK_ID) -n arabidopsis_wgs_accessions_split$(echo $SLURM_ARRAY_TASK_ID)
