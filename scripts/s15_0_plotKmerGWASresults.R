#Goal: take gemma output and make manhattan plot
rm(list = ls())
library(data.table)
library(ggplot2)
library(R.utils) #so that we can read gzipped files with fread

#Extract script arguments
#1: file name
#2: name for manhattan plot output
#3: number of threads for file reading
#4: p-value significance threshold
args = commandArgs(trailingOnly=TRUE)
inFileName = args[1]
outFilePrefix = args[2]
threadCount = as.numeric(args[3])
pThresh = as.numeric(args[4])

#Load GEMMA results
print(paste("Loading GEMMA results from", inFileName, "..."))
mysnps = fread(inFileName, nThread = threadCount)

#Determine p-value cutoffs
print("Calculating p-value cutoffs...")
mysnps$p_wald_bh = p.adjust(mysnps$p_wald, method = "BH")

#What is the bh-corrected cutoff for significance?
bhCutoff = -log10(max(mysnps$p_wald[which(mysnps$p_wald_bh < pThresh)]))
bfCutoff = -log10(pThresh/nrow(mysnps))

print("-log10(BH cutoff):")
print(bhCutoff)
print("-log10(BF cutoff):")
print(bfCutoff)

#Extract all significant k-mers
print("Writing list of significant k-mers...")
write.table(mysnps[which(mysnps$p_wald_bh < pThresh),"rs"], paste(outFilePrefix, "_sigKmers.txt", sep = ""), quote = F, row.names = F, col.names = F)

#Remove all but most significant kmers
print("Ordering k-mers by their significance...")
mysnps = mysnps[order(mysnps$p_wald),]
mysnps = mysnps[1:50000,]

#Convert p-value into log base 10 p-value
mysnps$p_wald = -log10(mysnps$p_wald)

#Plot results
print("Plotting results...")
ggplot(mysnps, aes(x = rs, y = p_wald)) +
	geom_point() + 
	geom_hline(yintercept=bhCutoff, linetype="dashed", color = "red", size=2) +
	geom_hline(yintercept=bfCutoff, color = "red", size=2) +
	theme_classic() +                                                 
	theme(axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
	labs(x = "k-mer (alphabetical order)", y = "-log10(p-value)")

#Save result
ggsave(paste(outFilePrefix, "_manhattanPlot.pdf", sep = ""))

