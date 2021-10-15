#!/bin/bash
#Split up k-mers so that we can loop over them across multiple cores
split --numeric-suffixes --suffix-length=4 -l 1 mvAnduvKmerGWASsigKmers.txt mvAnduvKmerGWASsigKmers_split

#Remove leading zeros from suffix
rename -n 's/split0{1,3}/split/' mvAnduvKmerGWASsigKmers_split*
rename 's/split0{1,3}/split/' mvAnduvKmerGWASsigKmers_split*
