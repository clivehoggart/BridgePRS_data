source('~/bin/my_forestplot.R')
source('~/bin/functions.R')
library(data.table)

pop <- c('AFR','SAS','EAS')
ridge.fstat <- list()
ridge.pv <- list()
for( i in 1:3 ){
    if( i<3 ){
        ridge.fstat[[i]] <- read.table(paste0('~/ukb/ridge_results/',pop[i],'_ukb_imputed.dat'))
    }else{
        ridge.fstat[[i]] <- fread('~/bbj/ridge_var_explained.dat')
    }
        ridge.pv[[i]] <- read.table(paste0('~/ukb/ridge_results_pv/',pop[i],'_imputed.dat'))
    if( i==3 ){
        ridge.pv[[i]] <- ridge.pv[[i]][match( ridge.fstat[[i]]$V1, ridge.pv[[i]]$V1),]
    }
    print( c( mean(ridge.fstat[[i]]$V2), mean(ridge.pv[[i]]$V2) ) )
}

pop <- c('AFR','SAS','EAS')
ridge.fstat <- list()
ridge.pv <- list()
m.diff <- vector()
se.diff <- vector()
for( i in 1:2 ){
    if( i<3 ){
        ridge.fstat[[i]] <- read.table(paste0('~/ukb/ridge_results/',pop[i],'_ukb_geno.dat'))
    }else{
        ridge.fstat[[i]] <- fread('~/bbj/ridge_var_explained.dat')
    }
        ridge.pv[[i]] <- read.table(paste0('~/ukb/ridge_results_pv/',pop[i],'_geno.dat'))
    if( i==3 ){
        ridge.pv[[i]] <- ridge.pv[[i]][match( ridge.fstat[[i]]$V1, ridge.pv[[i]]$V1),]
    }

    ridge.fstat.se <- ( ridge.fstat[[i]]$V4 - ridge.fstat[[i]]$V3 ) / (2*1.96)
    ridge.pv.se <- ( ridge.pv[[i]]$V4 - ridge.pv[[i]]$V3 ) / (2*1.96)
    ridge.fstat.se.avg <- sqrt(sum(ridge.fstat.se^2)) / 19
    ridge.pv.se.avg <- sqrt(sum(ridge.pv.se^2)) / 19
    se.diff[i] <- sqrt( ridge.fstat.se.avg^2 + ridge.pv.se.avg^2 )
    m.diff[i] <- mean(ridge.fstat[[i]]$V2 - ridge.pv[[i]]$V2)
    t.stat <- as.numeric(abs(m.diff[i]) / se.diff[i])

    print( c( mean(ridge.fstat[[i]]$V2), mean(ridge.pv[[i]]$V2),
             t.stat, pnorm(t.stat, lower.tail=FALSE) ) )
}

t.stat <- sum(m.diff) / sqrt(sum(se.diff^2))
