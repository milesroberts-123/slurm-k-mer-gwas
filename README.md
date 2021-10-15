# slurm-k-mer-gwas
k-mer-based GWAS on SLURM cluster

## Required software
fastqc and multiqc - to identify adapters in whole genome sequencing data

cutadapt - to trim adapters

[KMC](https://github.com/refresh-bio/KMC) - to count k-mers (could also use Jellyfish)

[GEMMA](https://github.com/genetics-statistics/GEMMA) - to build genome-wide association models 

[SPAdes](https://github.com/ablab/spades) - to assemble WGS reads into scaffolds

Bowtie or BLAST - for aligning k-mers, WGS reads, or scaffolds to a reference database or genome (if you have one)

[Seqkit](https://bioinf.shenwei.me/seqkit/) and [SeqTK](https://github.com/lh3/seqtk) - for general purpose sequence manipulation

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

### Part 2 creating k-mer presence/absence matrix
s07_count_kmers.bash - use KMC to count k-mers in WGS data. At this step you'll decide on the frequency threshold a k-mer must reach to be considered present (default: 10)

s08_0_makeKmerCountList.bash - Group k-mers from different accessions into seperate lists. This will help with parallel processing later

s08_1_estimateCoverage.bash - Use seqkit to count bases sequenced for each accession, which will be used to estimate coverage

s08_2_createCoverageCovariateFile.Rmd - An R-file to investigate variation in sequencing coverage across accessions, which will influence k-mer calling

s09_0_merge_kmers_parallel.bash - Use re-cursive join function in bash to merge k-mer counts for each accession

s09_1_merge_kmers_parallel.bash - Use recursive join function in a second stage to complete merging (merging should always be broken into stages to allow for parallel processing)

### Part 3 filtering k-mers
s10_remove_dups.bash - remove k-mers that have non-unique presence/absence patterns across accessions, this will likely remove over half of the k-mers in the current dataset

s11_splitKmerMatix.bash - break filtered k-mer matrix into pieces to allow for parallel processing in further filtering

s12_filterRareCommonKmers.bash - filter out rare k-mers and common k-mers (i.e. k-mers that are present in less than 5 % or more than 95 % of accessions respectively). Each k-mer that passes this filter will be converted into bimbam format for input to GEMMA

s13_concatFilteredKmers.bash - concatenate pieces of filtered k-mer presence/absence matrix

### Part 4 k-mer-based GWAS
s14_0_kmerGWASkinshipMatrix.bash - estimate kinship matrix using a random subset of k-mers (default 10,000,000). Then, impute missing phenotypes based on kinship matrix

s14_1_kmerMVGWAS.bash - perform a multivariate k-mer-based GWAS in GEMMA 

s14_2_kmerUVGWAS.bash - perform a univariate k-mer-based GWAS in GEMMA (I think running multiple types of models is a good practice)

s15_0_plotKmerGWASresults.R - R script for plotting results of k-mer-based GWAS

s15_1_plotKmerGWASresults.bash - job script to call s15_0 from slurm cluster

### Part 5 Interpreting results
s16_0_IntersectKmerLists.bash - find k-mers that are significant in multiple models

s16_1_splitKmerList.bash - break list of significant k-mers into pieces again for parallel processing

s16_2_loopOverSigKmers.bash - use a while loop to find the accessions each significant k-mer is present in, as well as find k-mers with identical presence/absence patterns to the significant k-mers

s17_0_prepForAssembly.bash - create individual directories for assembling the WGS reads containing each significant k-mer

s17_1_makeFqFile.bash - convert significant k-mer lists to fastq files because that's required by KMC filtering

s18_filterReadsWithSigKmers.bash - use KMC to filter out WGS reads that don't contain significant k-mers

s19_0_extractReadPairs.bash - for paired end data, find the mates to reads that contain significant k-mers

s19_1_localAssembly.bash - assemble WGS reads containing significant k-mers into scaffolds

s20_0_makeBLASTdb.bash - create a BLAST database of sequences you want to compare your scaffolds to

s20_1_BLAST.bash - BLAST the longest scaffold assembled from each k-mer to your reference database

Finally, you can look at the alignments given to you by BLAST to find potential variants and genes controlling your traits of interest
