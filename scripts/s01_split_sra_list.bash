#!/bin/bash
#Split up list of SRA runs and accessions so that download can occur over many cores
split --numeric-suffixes --suffix-length=4 -l 1 arabidopsis_wgs_sras.txt arabidopsis_wgs_sras_split
split --numeric-suffixes --suffix-length=4 -l 1 arabidopsis_wgs_accessions.txt arabidopsis_wgs_accessions_split

rename -n 's/split0{1,3}/split/' arabidopsis_wgs_sras_split*
rename 's/split0{1,3}/split/' arabidopsis_wgs_sras_split*

rename -n 's/split0{1,3}/split/' arabidopsis_wgs_accessions_split*
rename 's/split0{1,3}/split/' arabidopsis_wgs_accessions_split*


