library(data.table)
phenos <- c(50,21001,30080,30710,30140,30040,30630,30240,30610,30780,30130,30070,30670,30870,30220,30860,30530,30770,30150)
ptr.biome <- vector()
panel <- c('geno','hm','imputed')
pop <- "eur"
pop2 <- "eur"

n.model.var <- as.data.frame(matrix(ncol=3,nrow=length(phenos)))
colnames(n.model.var) <- panel
rownames(n.model.var) <- phenos
for( j in 3:3 ){
    for( i in 1:length(phenos) ){
        print( c(panel[j], phenos[i] ))
        if(panel[j]=='imputed'){
            score.file <- paste0('/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/imputed/test11/',phenos[i],'/',pop2,'_weighted_combined_snp_weights.dat')
            if( i==1 ){
                bim <- as.data.frame(matrix(ncol=6,nrow=0))
                for( chr in 1:22 ){
                    tmp <- fread(paste0('/sc/arion/projects/psychgen/ukb/usr/clive/ukb/imputed/chr',chr,'.bim'))
                    bim <- rbind( bim, tmp )
                }
            }
        }

        if(panel[j]=='hm'){
            score.file <- paste0('/sc/arion/work/hoggac01/ukb_pheno_results/',phenos[i],'/test5/',pop2,'_weighted_combined_snp_weights.dat')
            if( i==1 ){
                bim <- as.data.frame(matrix(ncol=6,nrow=0))
                for( chr in 1:22 ){
                    tmp <- fread(paste0('/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/analysis/quick_ridge/result/chr',chr,'.bim'))
                    bim <- rbind( bim, tmp )
                }
            }
        }

        if(panel[j]=='geno'){
            score.file <- paste0('/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/geno/test1/',phenos[i],'/',pop,'_weighted_combined_snp_weights.dat')
            if( i==1 ){
                bim <- fread('/sc/arion/projects/data-ark/ukb/application/ukb18177/genotyped/ukb18177.bim')
            }
        }
        score <- fread(score.file)
        n.model.var[i,j] <- nrow(score)

        new.id <- paste( bim$V1, bim$V4, sep=":" )
        ptr <- match( score$V1, bim$V2 )
        score <- data.frame( score, new.id[ptr] )
        colnames(score)[5] <- "newID"
        ptr.uniq <- which(!duplicated(score$newID))
        score <- score[ptr.uniq,]
        write.table( score, file=score.file, row.names=FALSE,
                    col.names=FALSE, quote=FALSE )
    }
}
