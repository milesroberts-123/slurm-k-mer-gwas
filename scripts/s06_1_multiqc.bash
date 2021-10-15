#Again, combine the many fastqc outputs
ml -* GCC/7.3.0-2.30 OpenMPI/3.1.1 MultiQC/1.7-Python-3.6.6
multiqc --filename multiqc_report_cleanReads.html fastqc_clean_reads/
