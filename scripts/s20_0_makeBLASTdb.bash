#!/bin/bash
#Create a BLAST database to align assembly scaffolds to
ml -* GCC/8.2.0-2.31.1 OpenMPI/3.1.3 BLAST+/2.9.0
makeblastdb -in GCF_000001735.4_TAIR10.1_genomic.fna -dbtype nucl -parse_seqids -out GCF_000001735.4_TAIR10.1_genomic
