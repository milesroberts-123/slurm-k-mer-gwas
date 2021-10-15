# slurm-k-mer-gwas
k-mer-based GWAS on SLURM cluster

## Required software
fastqc and multiqc - to identify adapters in whole genome sequencing data

cutadapt - to trim adapters

KMC - to count k-mers (could also use Jellyfish)

GEMMA - to build genome-wide association models 

SPAdes - to assemble WGS reads into scaffolds

Bowtie or BLAST - for aligning k-mers and/or WGS reads to reference genome (if you have one)

Seqkit and SeqTK - for general purpose sequence manipulation

R and python - for general purpose calculations, visualization

## Inputs
If you're using publically available data from the Short Read Archive:

List of SRA run numbers

List of accessions each SRA run number corresponds to (assuming each run number corresponds to one and only one accession)

Additionally:

List of phenotypes for input into GEMMA

A fasta sequence of a reference genome if you have one

See the example folder for examples of these files

## Scripts
s01_split_sra_list.bash - split

s02_download_rename_sra.bash

s03_download_rename_sra.bash

s04_0_fastqc.bash

s04_1_multiqc.bash

s05_clean_wgs_reads.bash

s06_0_fastqcCleanReads.bash

s06_1_multiqc.bash

s07_count_kmers.bash

s08_0_makeKmerCountList.bash

s08_1_estimateCoverage.bash

s08_2_createCoverageCovariateFile.Rmd

s09_0_merge_kmers_parallel.bash

s09_1_merge_kmers_parallel.bash

s10_remove_dups.bash

s11_splitKmerMatix.bash

s12_filterRareCommonKmers.bash

s13_concatFilteredKmers.bash

s14_0_kmerGWASkinshipMatrix.bash

s14_1_kmerMVGWAS.bash

s14_2_kmerUVGWAS.bash

s15_0_plotKmerGWASresults.R

s15_1_plotKmerGWASresults.bash

s16_0_IntersectKmerLists.bash

s16_1_splitKmerList.bash

s16_2_loopOverSigKmers.bash

s17_0_prepForAssembly.bash

s17_1_makeFqFile.bash

s18_filterReadsWithSigKmers.bash

s19_0_extractReadPairs.bash

s19_1_localAssembly.bash

s20_0_makeBLASTdb.bash

s20_1_BLAST.bash
