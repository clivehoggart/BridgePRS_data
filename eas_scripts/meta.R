library(data.table)
source("~/bin/functions.R")

args = commandArgs(trailingOnly=TRUE)

infile1 <- args[1]
infile2 <- args[2]
outfile <- args[3]

x1 <- fread(infile1)

ptr.use <- which( (x1$A1=="A" & x1$AX=="C") |
                  (x1$A1=="A" & x1$AX=="G") |
                  (x1$A1=="C" & x1$AX=="A") |
                  (x1$A1=="C" & x1$AX=="T") |
                  (x1$A1=="G" & x1$AX=="A") |
                  (x1$A1=="G" & x1$AX=="T") |
                  (x1$A1=="T" & x1$AX=="C") |
                  (x1$A1=="T" & x1$AX=="G") )
x1 <- x1[ptr.use,]

x2 <- fread(infile2)
snps <- intersect( x1$ID, x2$SNP )
x1 <- x1[match(snps,x1$ID),]
x2 <- x2[match(snps,x2$SNP),]

swtch <- ifelse( x1$AX==x2$REF & x1$A1==x2$ALT, 1, 0 )
swtch <- ifelse( x1$AX==x2$ALT & x1$A1==x2$REF, -1, swtch )
x1.a0.alt <- alt.strand( x1$AX )
x1.a1.alt <- alt.strand( x1$A1 )
swtch.alt <- ifelse( x1.a0.alt==x2$REF & x1.a1.alt==x2$ALT, 1, 0 )
swtch.alt <- ifelse( x1.a0.alt==x2$ALT & x1.a1.alt==x2$REF, -1, swtch.alt )

swtch1 <- ifelse( swtch!=0, swtch, swtch.alt )

my.meta <- meta2( cbind( x1$BETA, swtch1*x2$beta.real ), cbind(x1$SE,x2$se.real) )
out <- x1
out$BETA <- my.meta[,2]
out$SE <- my.meta[,3]
out$T_STAT <- my.meta[,4]
out$P <- my.meta[,1]

out <- out[ !is.na(out$P), ]

fwrite( out, outfile, sep=" " )

