#!/bin/bash
#Find k-mers common to all GWA models
comm -12 <(sort mvKmerGWAS_sigKmers.txt) <(sort uvKmerGWAS_FT16_sigKmers.txt) | comm -12 - <(sort uvKmerGWAS_RGR_sigKmers.txt) > mvAnduvKmerGWASsigKmers.txt
cat mvKmerGWAS_sigKmers.txt uvKmerGWAS_FT16_sigKmers.txt uvKmerGWAS_RGR_sigKmers.txt | sort -u > mvOruvKmerGWASsigKmers.txt