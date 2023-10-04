library(data.table)
phenos <- c(50,    21001, 30610,30220,30710,30150, 30780,30040,30130,30140, 30080,30870, 30860)

ptr.biome <- vector()

n.model.var <- as.data.frame(matrix(ncol=1,nrow=length(phenos)))
rownames(n.model.var) <- phenos
for( i in 1:length(phenos) ){
    print( phenos[i] )
    score.file <- paste0('/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ/test/',phenos[i],'/EAS_weighted_combined_snp_weights.dat')
    if( i==1 ){
        bim <- as.data.frame(matrix(ncol=6,nrow=0))
        for( chr in 1:22 ){
            tmp <- fread(paste0('/sc/arion/projects/psychgen/ukb/usr/clive/ukb/imputed/chr',chr,'.bim'))
            bim <- rbind( bim, tmp )
        }
    }
    score <- fread(score.file)
    n.model.var[i] <- nrow(score)

    new.id <- paste( bim$V1, bim$V4, sep=":" )
    ptr <- match( score$V1, bim$V2 )
    score <- data.frame( score, new.id[ptr] )
    colnames(score)[5] <- "newID"
    ptr.uniq <- which(!duplicated(score$newID))
    score <- score[ptr.uniq,]
    write.table( score, file=score.file, row.names=FALSE,
                col.names=FALSE, quote=FALSE )
}

