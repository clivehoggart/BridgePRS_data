library(data.table)
source("~/bin/functions.R")

args = commandArgs(trailingOnly=TRUE)

infile1 <- args[1]
infile2 <- args[2]
outfile <- args[3]

x1 <- fread(infile1)
x2 <- fread(infile2)
snps <- intersect( x1$ID, x2$ID )
x1 <- x1[match(snps,x1$ID),]
x2 <- x2[match(snps,x2$ID),]

my.meta <- meta2( cbind(x1$BETA,x2$BETA), cbind(x1$SE,x2$SE) )
out <- x1
out$BETA <- my.meta[,2]
out$SE <- my.meta[,3]
out$T_STAT <- my.meta[,4]
out$P <- my.meta[,1]

out <- out[ !is.na(out$P), ]

fwrite( out, outfile, sep=" " )

