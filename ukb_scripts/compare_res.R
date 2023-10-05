library(data.table)

phenos <- c(50, 21001, 30080, 30710, 30140, 30040, 30630, 30240, 30610, 30780, 30130, 30070, 30670, 30870, 30220, 30860, 30530, 30770, 30150)

pops <- c('AFR','SAS')
pops2 <- c('afr','SAS')

ridge.eur <- matrix(ncol=3,nrow=length(phenos) )
for( i in 1:length(phenos) ){
    tmp <- fread(paste0('/sc/arion/work/hoggac01/ukb_pheno_results/',phenos[i],'/test_imputed/eur_weighted_combined_var_explained.txt'))
    ridge.eur[i,]=as.numeric(tmp[2,2:4])
}

cs.afr <- list()
csx.afr <- list()
Bridge.afr <- list()
prsice.meta.afr <- list()
comp <- list()
for( j in 1:length(pops) ){
    cs.afr[[j]] <- fread(paste0('~/ukb/cs_res/',pops[j],'.dat'))
    prsice.meta.afr[[j]] <- fread(paste0('~/ukb/prsice_res/',pops[j],'_imputed.dat'))
    csx.afr[[j]] <- fread(paste0('~/csx_results/',pops[j],'_ukb_imputed.dat'))

    Bridge.afr[[j]] <- matrix(ncol=3,nrow=length(phenos) )
    for( i in 1:length(phenos) ){
        tmp <- fread(paste0('/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/imputed/test11/',phenos[i],'/',pops2[j],'_weighted_combined_var_explained.txt'))
        Bridge.afr[[j]][i,]=as.numeric(tmp[4,3:5])
    }
    cs.afr[[j]] <- cs.afr[[j]][match(phenos,cs.afr[[j]]$V1),]
    csx.afr[[j]] <- csx.afr[[j]][match(phenos,csx.afr[[j]]$V1),]
    prsice.meta.afr[[j]] <- prsice.meta.afr[[j]][match(phenos,prsice.meta.afr[[j]]$V1),]

    comp[[j]] <- matrix(nrow=4,ncol=3)
    rownames(comp[[j]]) <- c('prsice.meta','CS.mult','CSx','Bridge')

    comp[[j]][1,1] <- median(prsice.meta.afr[[j]]$V2 / ridge.eur[,1])
    comp[[j]][1,2] <- median(prsice.meta.afr[[j]]$V2)
    comp[[j]][1,3] <- mean(prsice.meta.afr[[j]]$V2)

    comp[[j]][2,1] <- median(cs.afr[[j]]$V2 / ridge.eur[,1])
    comp[[j]][2,2] <- median(cs.afr[[j]]$V2)
    comp[[j]][2,3] <- mean(cs.afr[[j]]$V2)

    comp[[j]][4,1] <- median(Bridge.afr[[j]][,1] / ridge.eur[,1])
    comp[[j]][4,2] <- median(Bridge.afr[[j]][,1])
    comp[[j]][4,3] <- mean(Bridge.afr[[j]][,1])

    comp[[j]][3,1] <- median(csx.afr[[j]]$V2 / ridge.eur[,1])
    comp[[j]][3,2] <- median(csx.afr[[j]]$V2)
    comp[[j]][3,3] <- mean(csx.afr[[j]]$V2)
}
