library(data.table)
phenos <- c(50, 21001, 30610, 30220, 30710, 30150, 30780,
            30040, 30130, 30140,  30080, 30870, 30860)
phenos2 <- c('Height', 'BMI', 'ALP', 'Baso', 'CRP', 'Eosino','LDL-C',
             'MCV', 'Mono', 'Neutro', 'Plt', 'TG', 'TP')

n.height <- 191787
n.bmi <-  173430

ukb.path <- "/sc/arion/projects/psychgen/ukb/usr/clive/ukb/impute_gwas/"
bbj.path <- "/sc/arion/projects/psychgen/ukb/usr/clive/BBJ/BBJ."
ukb.qc <- fread('/sc/arion/projects/psychgen/ukb/usr/clive/ukb/imputed/chr.EUR.qced.snps.snplist',header=FALSE)
for( i in 13:13 ){
    ukb <- matrix( ncol=13, nrow=0 )
    for( chr in 1:22 ){
        ukb <- rbind( ukb,
                     fread(paste0( ukb.path, phenos[i],"/EUR.chr",chr,
                                  ".Phenotype.glm.linear.gz" ), data.table=FALSE) )
    }
    bbj.file <- paste0( bbj.path, phenos2[i], ".autosome.txt.gz" )
    bbj  <- fread( bbj.file, data.table=FALSE )
#    ptr.rm <- match("beta.real",colnames(bbj))
#    bbj <- bbj[,-ptr.rm]

    if( i>1 ){
        ptr.bbj <- which( 0.01 < bbj$Frq&bbj$Frq < 0.99 & bbj$Rsq>=0.99 )
        bbj <- bbj[ptr.bbj,]
        maf.bbj <- ifelse( bbj$Frq<0.5, bbj$Frq, 1-bbj$Frq )
    }
    if( i==1 ){
        ptr.bbj <- which( 0.01 < bbj$MAF & bbj$Rsq>=0.99 )
        bbj <- bbj[ptr.bbj,]
        n.bbj <- n.height
        maf.bbj <- bbj$MAF
    }

    if( i==2 ){
        n.bbj <- n.bmi
    }

    if( i>2 ){
        snps <- intersect( ukb.qc$V1, intersect( bbj$SNP, ukb$ID ) )
        ptr.bbj <- match( snps, bbj$SNP )
        n.bbj <- bbj$N
    }
    if( i <= 2 ){
        id.ukb <- paste( ukb[,'#CHROM'], ukb$POS, sep=":" )
        id.bbj <- paste( bbj$CHR, bbj$POS, sep=":" )
        id.intersect <- intersect( id.bbj, id.ukb )
        snps <- ukb$ID[match( id.intersect, id.ukb )]
        ptr.bbj <- match( id.intersect, id.bbj )
    }
    ptr.ukb <- match( snps, ukb$ID )

    ptr.use.ukb <- which( ukb$A1_FREQ > 0.4 )
    ptr.use.bbj <- which( maf.bbj > 0.4 )
    sigma.ukb <- sqrt(median(
    (2*ukb$OBS_CT * ukb$SE * ukb$SE * ukb$A1_FREQ * (1-ukb$A1_FREQ))[ptr.use.ukb], na.rm=TRUE ))
    sigma.bbj <- sqrt(median(
    (2*n.bbj * bbj$SE * bbj$SE * maf.bbj * (1-maf.bbj))[ptr.use.bbj], na.rm=TRUE ))

    print(c( sigma.ukb, sigma.bbj, sigma.ukb/sigma.bbj ))
    print(c( sd(ukb$BETA), sd(bbj$BETA),  sd(ukb$BETA)/sd(bbj$BETA) ))
    print(length(snps))

    beta.real <- bbj$BETA * sigma.ukb
    se.real <- bbj$SE * sigma.ukb

    if( i <= 2 ){
        if( i==1 ){
            rsid <- bbj$Variants
        }
        if( i==2 ){
            rsid <- bbj$SNP
        }
        rsid[ptr.bbj] <- snps
#        bbj <- data.frame( bbj, rsid, beta.real, se.real )
        bbj <- data.frame( bbj, rsid, se.real )
    }
    if( i > 2 ){
#        bbj <- data.frame( bbj, beta.real, se.real )
        bbj <- data.frame( bbj, se.real )
    }
    write.table( bbj, bbj.file, row.names=FALSE, quote=FALSE )
}
write.table( snps, "/sc/arion/projects/psychgen/ukb/usr/clive/BBJ/bbj.snplist", quote=FALSE, row.names=FALSE, col.names=FALSE )
