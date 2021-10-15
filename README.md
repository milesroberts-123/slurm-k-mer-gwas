# slurm-k-mer-gwas
k-mer-based GWAS on SLURM cluster

## Required software
fastqc and multiqc - to identify adapters in whole genome sequencing data

cutadapt - to trim adapters

KMC - to count k-mers (could also use Jellyfish)

GEMMA - to build genome-wide association models 

SPAdes - to assemble WGS reads into scaffolds

Bowtie or BLAST - for aligning k-mers, WGS reads, or scaffolds to a reference database or genome (if you have one)

Seqkit and SeqTK - for general purpose sequence manipulation

R and python - for general purpose calculations, visualization

## Inputs
If you're using publically available data from the Short Read Archive:

* List of SRA run numbers

* List of accessions each SRA run number corresponds to (assuming each run number corresponds to one and only one accession)

Additionally:

* List of phenotypes for input into GEMMA (see GEMMA manual for more details). These phenotypes should also be normalized using the qqnorm function

* A fasta sequence of a reference genome if you have one

See the example folder for examples of these files

## Scripts

### Part 1 preparing sequencing data
s01_split_sra_list.bash - split SRA run numbers and accessions numbers into multiple files for parallel processsing

s02_download_rename_sra.bash - bash script to download and rename SRA data

s03_download_rename_sra.bash - job script to call s02 from slurm cluster

s04_0_fastqc.bash - quality check reads, find adapters

s04_1_multiqc.bash - combine fastqc outputs for each read, look at output html file to find samples with adapters, then go to each sample's html file to get adapter sequences

s05_clean_wgs_reads.bash - remove adapter sequences, N bases, and low-quality bases from reads, set lower limit on read length (which will determine your k-mer length)

s06_0_fastqcCleanReads.bash - quality check after cutadapt, confirm higher quality

s06_1_multiqc.bash - combine fastqc outputs for each run

### Part 2 counting k-mers
s07_count_kmers.bash - use KMC to count k-mers in WGS data. At this step you'll decide on the frequency threshold a k-mer must reach to be considered present (default: 10)

s08_0_makeKmerCountList.bash - 

s08_1_estimateCoverage.bash - Use seqkit to count bases sequenced for each accession, which will be used to estimate coverage

s08_2_createCoverageCovariateFile.Rmd - An R-file to investigate variation in sequencing coverage across accessions, which will influence k-mer calling

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
