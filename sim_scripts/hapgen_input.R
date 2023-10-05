library(data.table)

args <- commandArgs(trailingOnly=TRUE)
chr <- args[1]
dir <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/input"

x <- fread(paste0(dir,'/chr',chr,'.dat.gz'),data.table=FALSE)
hm <- fread('~/1000G/hapmap3_r1_b36_fwd_consensus.qc.poly.recode.map',data.table=FALSE)
eas <- fread('~/BridgePRS/data/EAS_IDs.txt',header=FALSE)
eur <- fread('~/BridgePRS/data/EUR_IDs.txt',header=FALSE)
afr <- fread('~/BridgePRS/data/AFR_IDs.txt',header=FALSE)
ptr.eas <- match( eas$V1, colnames(x) )
ptr.eur <- match( eur$V1, colnames(x) )
ptr.afr <- match( afr$V1, colnames(x) )
ptr.afr <- ptr.afr[which(!is.na(ptr.afr))]

ptr.use <- which( (x$REF=="A" & x$ALT=="C") |
                  (x$REF=="A" & x$ALT=="G") |
                  (x$REF=="C" & x$ALT=="A") |
                  (x$REF=="C" & x$ALT=="T") |
                  (x$REF=="G" & x$ALT=="A") |
                  (x$REF=="G" & x$ALT=="T") |
                  (x$REF=="T" & x$ALT=="C") |
                  (x$REF=="T" & x$ALT=="G") )
hm.snps <- intersect( hm$V2, x$ID[ptr.use] )
ptr.hm <- match( hm.snps, x$ID )

write.table( x[ptr.hm,ptr.eas], paste0(dir,"/chr",chr,"_eas.bar"), col.names=FALSE, row.names=FALSE, quote=FALSE )
write.table( x[ptr.hm,ptr.eur], paste0(dir,"/chr",chr,"_eur.bar"), col.names=FALSE, row.names=FALSE, quote=FALSE )
write.table( x[ptr.hm,ptr.afr], paste0(dir,"/chr",chr,"_afr.bar"), col.names=FALSE, row.names=FALSE, quote=FALSE )

write.table( x[ptr.hm,c(3,2,4,5)], paste0(dir,"/chr",chr,".leg"), row.names=FALSE, quote=FALSE )

tmp1 <- strsplit(x$INFO[ptr.hm],";")

eas.af <- sapply( tmp1, getElement, 6 )
tmp <- strsplit( eas.af, "=" )
eas.af <- as.numeric(sapply( tmp, getElement, 2 ))

afr.af <- sapply( tmp1, getElement, 8 )
tmp <- strsplit( afr.af, "=" )
afr.af <- as.numeric(sapply( tmp, getElement, 2 ))

eur.af <- sapply( tmp1, getElement, 9 )
tmp <- strsplit( eur.af, "=" )
eur.af <- as.numeric(sapply( tmp, getElement, 2 ))

eur.af <- ifelse( eur.af>0.5, 1-eur.af, eur.af )
eas.af <- ifelse( eas.af>0.5, 1-eas.af, eas.af )
afr.af <- ifelse( afr.af>0.5, 1-afr.af, afr.af )

ptr <- which( eur.af>0.01 )
write.table( x[ptr.hm[ptr[1]],2], paste0(dir,"/dl",chr,"_eur.bar"), col.names=FALSE, row.names=FALSE, quote=FALSE )

ptr <- which( afr.af>0.01 )
write.table( x[ptr.hm[ptr[1]],2], paste0(dir,"/dl",chr,"_afr.bar"), col.names=FALSE, row.names=FALSE, quote=FALSE )

ptr <- which( eas.af>0.01 )
write.table( x[ptr.hm[ptr[1]],2], paste0(dir,"/dl",chr,"_eas.bar"), col.names=FALSE, row.names=FALSE, quote=FALSE )

