library(data.table)

dir <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/Bridge/herit50_half_n/"
analysis <- c("with_causal/SCORE","wo_causal/SCORE")
#              ,"10k/SCORE","wo_causal_10k/SCORE",
#              "5k/SCORE","wo_causal_5k/SCORE" )
res.afr <- list()
res.afr1 <- list()
res.afr2 <- list()
res.eas <- list()
res.eas1 <- list()
res.eas2 <- list()

k <- 2
ext <- c('_ukb.dat','.dat')

for( j in 1:length(analysis) ){
    res.afr[[j]] <- matrix(ncol=3,nrow=30)
    res.eas[[j]] <- matrix(ncol=3,nrow=30)
    res.afr1[[j]] <- matrix(ncol=3,nrow=30)
    res.eas1[[j]] <- matrix(ncol=3,nrow=30)
    res.afr2[[j]] <- matrix(ncol=3,nrow=30)
    res.eas2[[j]] <- matrix(ncol=3,nrow=30)
    for( i in 1:30 ){
        infile <- paste0(dir,analysis[j],i,"_AVG/afr_weighted_combined_var_explained.txt")
        if( file.exists(infile) ){
            tmp <- fread(infile)
            res.afr[[j]][i,] <- as.numeric(tmp[4,3:5])
            res.afr1[[j]][i,] <- as.numeric(tmp[3,3:5])
            res.afr2[[j]][i,] <- as.numeric(tmp[2,3:5])
        }
        if( !file.exists(infile) ){
            print(infile)
        }

        infile <- paste0(dir,analysis[j],i,"_AVG/eas_weighted_combined_var_explained.txt")
        if( file.exists(infile) ){
            tmp <- fread(infile)
            res.eas[[j]][i,] <- as.numeric(tmp[4,3:5])
            res.eas1[[j]][i,] <- as.numeric(tmp[3,3:5])
            res.eas2[[j]][i,] <- as.numeric(tmp[2,3:5])
        }
        if( !file.exists(infile) ){
            print(infile)
        }
    }
}
names(res.afr) <- analysis
names(res.eas) <- analysis

analysis <- c('20k.with_causal','20k.wo_causal')
#              ,'10k.with_causal','10k.wo_causal',
#              '5k.with_causal','5k.wo_causal')
for( ii in 1:2 ){
    write.table(res.eas[[ii]],
                paste0('ridge_res50_half_n/eas_',analysis[ii],ext[k]),
                quote=FALSE,row.names=FALSE,col.names=FALSE)
    write.table(res.afr[[ii]],
                paste0('ridge_res50_half_n/afr_',analysis[ii],ext[k]),
                quote=FALSE,row.names=FALSE,col.names=FALSE)
}

