analysis <- c('20k.with_causal','20k.wo_causal')
size <- c('20k')
causal <- c('.with_causal','.wo_causal')
#              ,'10k.with_causal','10k.wo_causal',
#              '5k.with_causal','5k.wo_causal')

causal.csx <- c('WITHcausal','NOcausal')

csx.afr.ukb <- list()
csx.eas.ukb <- list()
summary.csx.afr.ukb <- matrix(ncol=3,nrow=2)
summary.csx.eas.ukb <- matrix(ncol=3,nrow=2)
for( j in 1:1 ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
        csx.eas.ukb[[ii]] <- read.table(paste0('csx_res25_ukb/eas_20k',
                                               causal[k],'.dat'))
        csx.afr.ukb[[ii]] <- read.table(paste0('csx_res25_ukb/afr_20k',
                                               causal[k],'.dat'))
        csx.eas.ukb[[ii]] <-  csx.eas.ukb[[ii]][order(csx.eas.ukb[[ii]]$V1,decreasing=FALSE),]
        csx.afr.ukb[[ii]] <-  csx.afr.ukb[[ii]][order(csx.afr.ukb[[ii]]$V1,decreasing=FALSE),]
        summary.csx.eas.ukb[ii,1] <- mean(csx.eas.ukb[[ii]][1:10,2])
        summary.csx.eas.ukb[ii,2] <- mean(csx.eas.ukb[[ii]][11:20,2])
        summary.csx.eas.ukb[ii,3] <- mean(csx.eas.ukb[[ii]][21:30,2])
        summary.csx.afr.ukb[ii,1] <- mean(csx.afr.ukb[[ii]][1:10,2])
        summary.csx.afr.ukb[ii,2] <- mean(csx.afr.ukb[[ii]][11:20,2])
        summary.csx.afr.ukb[ii,3] <- mean(csx.afr.ukb[[ii]][21:30,2])
    }
}
colnames(summary.csx.eas.ukb) <- c('1%','5%','10%')
rownames(summary.csx.eas.ukb) <- analysis
colnames(summary.csx.afr.ukb) <- c('1%','5%','10%')
rownames(summary.csx.afr.ukb) <- analysis

csx.afr <- list()
csx.eas <- list()
summary.csx.afr <- matrix(ncol=3,nrow=2)
summary.csx.eas <- matrix(ncol=3,nrow=2)
for( j in 1:1 ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
        csx.eas[[ii]] <- read.table(paste0('csx_res25/eas_20k',
                                          causal[k],'.dat'))
        csx.afr[[ii]] <- read.table(paste0('csx_res25/afr_20k',
                                          causal[k],'.dat'))
        csx.eas[[ii]] <-  csx.eas[[ii]][order(csx.eas[[ii]]$V1,decreasing=FALSE),]
        csx.afr[[ii]] <-  csx.afr[[ii]][order(csx.afr[[ii]]$V1,decreasing=FALSE),]
        ptr1 <- match( 1:10, csx.eas[[ii]]$V1 )
        ptr1 <- ptr1[!is.na(ptr1)]
        ptr2 <- match( 11:20, csx.eas[[ii]]$V1 )
        ptr2 <- ptr2[!is.na(ptr2)]
        ptr3 <- match( 21:30, csx.eas[[ii]]$V1 )
        ptr3 <- ptr3[!is.na(ptr3)]
        summary.csx.eas[ii,1] <- mean(csx.eas[[ii]][ptr1,2])
        summary.csx.eas[ii,2] <- mean(csx.eas[[ii]][ptr2,2])
        summary.csx.eas[ii,3] <- mean(csx.eas[[ii]][ptr3,2])
        ptr1 <- match( 1:10, csx.afr[[ii]]$V1 )
        ptr1 <- ptr1[!is.na(ptr1)]
        ptr2 <- match( 11:20, csx.afr[[ii]]$V1 )
        ptr2 <- ptr2[!is.na(ptr2)]
        ptr3 <- match( 21:30, csx.afr[[ii]]$V1 )
        ptr3 <- ptr3[!is.na(ptr3)]
        summary.csx.afr[ii,1] <- mean(csx.afr[[ii]][ptr1,2])
        summary.csx.afr[ii,2] <- mean(csx.afr[[ii]][ptr2,2])
        summary.csx.afr[ii,3] <- mean(csx.afr[[ii]][ptr3,2])
    }
}
colnames(summary.csx.eas) <- c('1%','5%','10%')
rownames(summary.csx.eas) <- analysis
colnames(summary.csx.afr) <- c('1%','5%','10%')
rownames(summary.csx.afr) <- analysis

prsice.afr <- list()
prsice.eas <- list()
summary.prsice.afr <- matrix(ncol=3,nrow=2)
summary.prsice.eas <- matrix(ncol=3,nrow=2)
for( j in 1:1 ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
        prsice.eas[[ii]] <- read.table(paste0('prsice_res/eas_',
                                               size[j],causal[k],'.dat'))
        prsice.afr[[ii]] <- read.table(paste0('prsice_res/afr_',
                                              size[j],causal[k],'.dat'))
        prsice.eas[[ii]] <-  prsice.eas[[ii]][order(prsice.eas[[ii]]$V1,decreasing=FALSE),]
        prsice.afr[[ii]] <-  prsice.afr[[ii]][order(prsice.afr[[ii]]$V1,decreasing=FALSE),]
        summary.prsice.eas[ii,1] <- mean(prsice.eas[[ii]][1:10,2])
        summary.prsice.eas[ii,2] <- mean(prsice.eas[[ii]][11:20,2])
        summary.prsice.eas[ii,3] <- mean(prsice.eas[[ii]][21:30,2])
        summary.prsice.afr[ii,1] <- mean(prsice.afr[[ii]][1:10,2])
        summary.prsice.afr[ii,2] <- mean(prsice.afr[[ii]][11:20,2])
        summary.prsice.afr[ii,3] <- mean(prsice.afr[[ii]][21:30,2])
    }
}
colnames(summary.prsice.eas) <- c('1%','5%','10%')
rownames(summary.prsice.eas) <- analysis
colnames(summary.prsice.afr) <- c('1%','5%','10%')
rownames(summary.prsice.afr) <- analysis

ridge.afr <- list()
ridge.eas <- list()
summary.ridge.afr <- matrix(ncol=3,nrow=2)
summary.ridge.eas <- matrix(ncol=3,nrow=2)
for( j in 1:length(size) ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
        ridge.eas[[ii]] <- read.table(paste0('ridge_res/eas_',
                                             size[j],causal[k],'.dat'))
        ridge.afr[[ii]] <- read.table(paste0('ridge_res/afr_',
                                             size[j],causal[k],'.dat'))
        summary.ridge.eas[ii,1] <- mean(ridge.eas[[ii]][1:10,1])
        summary.ridge.eas[ii,2] <- mean(ridge.eas[[ii]][11:20,1])
        summary.ridge.eas[ii,3] <- mean(ridge.eas[[ii]][21:30,1])
        summary.ridge.afr[ii,1] <- mean(ridge.afr[[ii]][1:10,1])
        summary.ridge.afr[ii,2] <- mean(ridge.afr[[ii]][11:20,1])
        summary.ridge.afr[ii,3] <- mean(ridge.afr[[ii]][21:30,1])
    }
}
colnames(summary.ridge.eas) <- c('1%','5%','10%')
rownames(summary.ridge.eas) <- analysis
colnames(summary.ridge.afr) <- c('1%','5%','10%')
rownames(summary.ridge.afr) <- analysis

ridge.afr.pv <- list()
ridge.eas.pv <- list()
summary.ridge.afr.pv <- matrix(ncol=3,nrow=2)
summary.ridge.eas.pv <- matrix(ncol=3,nrow=2)
for( j in 1:length(size) ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
        ridge.eas.pv[[ii]] <- read.table(paste0('ridge_res_pv/eas_',
                                             size[j],causal[k],'.dat'))
        ridge.afr.pv[[ii]] <- read.table(paste0('ridge_res_pv/afr_',
                                             size[j],causal[k],'.dat'))
        summary.ridge.eas.pv[ii,1] <- mean(ridge.eas.pv[[ii]][1:10,1])
        summary.ridge.eas.pv[ii,2] <- mean(ridge.eas.pv[[ii]][11:20,1])
        summary.ridge.eas.pv[ii,3] <- mean(ridge.eas.pv[[ii]][21:30,1])
        summary.ridge.afr.pv[ii,1] <- mean(ridge.afr.pv[[ii]][1:10,1])
        summary.ridge.afr.pv[ii,2] <- mean(ridge.afr.pv[[ii]][11:20,1])
        summary.ridge.afr.pv[ii,3] <- mean(ridge.afr.pv[[ii]][21:30,1])
    }
}
colnames(summary.ridge.eas.pv) <- c('1%','5%','10%')
rownames(summary.ridge.eas.pv) <- analysis
colnames(summary.ridge.afr.pv) <- c('1%','5%','10%')
rownames(summary.ridge.afr.pv) <- analysis

ridge.afr.ukb <- list()
ridge.eas.ukb <- list()
summary.ridge.afr.ukb <- matrix(ncol=3,nrow=2)
summary.ridge.eas.ukb <- matrix(ncol=3,nrow=2)
for( j in 1:length(size) ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
        ridge.eas.ukb[[ii]] <- read.table(paste0('ridge_res/eas_',
                                             size[j],causal[k],'_ukb.dat'))
        ridge.afr.ukb[[ii]] <- read.table(paste0('ridge_res/afr_',
                                             size[j],causal[k],'_ukb.dat'))
        summary.ridge.eas.ukb[ii,1] <- mean(ridge.eas.ukb[[ii]][1:10,1])
        summary.ridge.eas.ukb[ii,2] <- mean(ridge.eas.ukb[[ii]][11:20,1])
        summary.ridge.eas.ukb[ii,3] <- mean(ridge.eas.ukb[[ii]][21:30,1])
        summary.ridge.afr.ukb[ii,1] <- mean(ridge.afr.ukb[[ii]][1:10,1])
        summary.ridge.afr.ukb[ii,2] <- mean(ridge.afr.ukb[[ii]][11:20,1])
        summary.ridge.afr.ukb[ii,3] <- mean(ridge.afr.ukb[[ii]][21:30,1])
    }
}
colnames(summary.ridge.eas.ukb) <- c('1%','5%','10%')
rownames(summary.ridge.eas.ukb) <- analysis
colnames(summary.ridge.afr.ukb) <- c('1%','5%','10%')
rownames(summary.ridge.afr.ukb) <- analysis

cs.afr <- list()
cs.eas <- list()
summary.cs.afr <- matrix(ncol=3,nrow=2)
summary.cs.eas <- matrix(ncol=3,nrow=2)
for( j in 1:1 ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
            cs.eas[[ii]] <- read.table(paste0('cs_res/eas_',
                                              size[j],causal[k],'.dat'))
            cs.afr[[ii]] <- read.table(paste0('cs_res/afr_',
                                              size[j],causal[k],'.dat'))
            cs.eas[[ii]] <-  cs.eas[[ii]][order(cs.eas[[ii]]$V1,decreasing=FALSE),]
            cs.afr[[ii]] <-  cs.afr[[ii]][order(cs.afr[[ii]]$V1,decreasing=FALSE),]
            summary.cs.eas[ii,1] <- mean(cs.eas[[ii]][1:10,2])
            summary.cs.eas[ii,2] <- mean(cs.eas[[ii]][11:20,2])
            summary.cs.eas[ii,3] <- mean(cs.eas[[ii]][21:30,2])
            summary.cs.afr[ii,1] <- mean(cs.afr[[ii]][1:10,2])
            summary.cs.afr[ii,2] <- mean(cs.afr[[ii]][11:20,2])
            summary.cs.afr[ii,3] <- mean(cs.afr[[ii]][21:30,2])
    }
}
colnames(summary.cs.eas) <- c('1%','5%','10%')
rownames(summary.cs.eas) <- analysis
colnames(summary.cs.afr) <- c('1%','5%','10%')
rownames(summary.cs.afr) <- analysis

##################
# 50% heritability
##################
prsice.afr50 <- list()
prsice.eas50 <- list()
summary.prsice.afr50 <- matrix(ncol=3,nrow=2)
summary.prsice.eas50 <- matrix(ncol=3,nrow=2)
for( j in 1:1 ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
        prsice.eas50[[ii]] <- read.table(paste0('prsice_res50/eas_',
                                               size[j],causal[k],'.dat'))
        prsice.afr50[[ii]] <- read.table(paste0('prsice_res50/afr_',
                                              size[j],causal[k],'.dat'))
        prsice.eas50[[ii]] <-  prsice.eas50[[ii]][order(prsice.eas50[[ii]]$V1,decreasing=FALSE),]
        prsice.afr50[[ii]] <-  prsice.afr50[[ii]][order(prsice.afr50[[ii]]$V1,decreasing=FALSE),]
        summary.prsice.eas50[ii,1] <- mean(prsice.eas50[[ii]][1:10,2])
        summary.prsice.eas50[ii,2] <- mean(prsice.eas50[[ii]][11:20,2])
        summary.prsice.eas50[ii,3] <- mean(prsice.eas50[[ii]][21:30,2])
        summary.prsice.afr50[ii,1] <- mean(prsice.afr50[[ii]][1:10,2])
        summary.prsice.afr50[ii,2] <- mean(prsice.afr50[[ii]][11:20,2])
        summary.prsice.afr50[ii,3] <- mean(prsice.afr50[[ii]][21:30,2])
    }
}
colnames(summary.prsice.eas50) <- c('1%','5%','10%')
rownames(summary.prsice.eas50) <- analysis
colnames(summary.prsice.afr50) <- c('1%','5%','10%')
rownames(summary.prsice.afr50) <- analysis

ridge.afr50 <- list()
ridge.eas50 <- list()
summary.ridge.afr50 <- matrix(ncol=3,nrow=2)
summary.ridge.eas50 <- matrix(ncol=3,nrow=2)
for( j in 1:length(size) ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
        ridge.eas50[[ii]] <- read.table(paste0('ridge_res50/eas_',
                                             size[j],causal[k],'.dat'))
        ridge.afr50[[ii]] <- read.table(paste0('ridge_res50/afr_',
                                             size[j],causal[k],'.dat'))
        summary.ridge.eas50[ii,1] <- mean(ridge.eas50[[ii]][1:10,1])
        summary.ridge.eas50[ii,2] <- mean(ridge.eas50[[ii]][11:20,1])
        summary.ridge.eas50[ii,3] <- mean(ridge.eas50[[ii]][21:30,1])
        summary.ridge.afr50[ii,1] <- mean(ridge.afr50[[ii]][1:10,1])
        summary.ridge.afr50[ii,2] <- mean(ridge.afr50[[ii]][11:20,1])
        summary.ridge.afr50[ii,3] <- mean(ridge.afr50[[ii]][21:30,1])
    }
}
colnames(summary.ridge.eas50) <- c('1%','5%','10%')
rownames(summary.ridge.eas50) <- analysis
colnames(summary.ridge.afr50) <- c('1%','5%','10%')
rownames(summary.ridge.afr50) <- analysis

ridge.afr50.pv <- list()
ridge.eas50.pv <- list()
summary.ridge.afr50.pv <- matrix(ncol=3,nrow=2)
summary.ridge.eas50.pv <- matrix(ncol=3,nrow=2)
for( j in 1:length(size) ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
        ridge.eas50.pv[[ii]] <- read.table(paste0('ridge_res50_pv/eas_',
                                             size[j],causal[k],'.dat'))
        ridge.afr50.pv[[ii]] <- read.table(paste0('ridge_res50_pv/afr_',
                                             size[j],causal[k],'.dat'))
        summary.ridge.eas50.pv[ii,1] <- mean(ridge.eas50.pv[[ii]][1:10,1])
        summary.ridge.eas50.pv[ii,2] <- mean(ridge.eas50.pv[[ii]][11:20,1])
        summary.ridge.eas50.pv[ii,3] <- mean(ridge.eas50.pv[[ii]][21:30,1])
        summary.ridge.afr50.pv[ii,1] <- mean(ridge.afr50.pv[[ii]][1:10,1])
        summary.ridge.afr50.pv[ii,2] <- mean(ridge.afr50.pv[[ii]][11:20,1])
        summary.ridge.afr50.pv[ii,3] <- mean(ridge.afr50.pv[[ii]][21:30,1])
    }
}
colnames(summary.ridge.eas50.pv) <- c('1%','5%','10%')
rownames(summary.ridge.eas50.pv) <- analysis
colnames(summary.ridge.afr50.pv) <- c('1%','5%','10%')
rownames(summary.ridge.afr50.pv) <- analysis

cs.afr50 <- list()
cs.eas50 <- list()
summary.cs.afr50 <- matrix(ncol=3,nrow=2)
summary.cs.eas50 <- matrix(ncol=3,nrow=2)
for( j in 1:1 ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
            cs.eas50[[ii]] <- read.table(paste0('cs_res50/eas_',
                                              size[j],causal[k],'.dat'))
            cs.afr50[[ii]] <- read.table(paste0('cs_res50/afr_',
                                              size[j],causal[k],'.dat'))
            cs.eas50[[ii]] <-  cs.eas50[[ii]][order(cs.eas50[[ii]]$V1,decreasing=FALSE),]
            cs.afr50[[ii]] <-  cs.afr50[[ii]][order(cs.afr50[[ii]]$V1,decreasing=FALSE),]
            summary.cs.eas50[ii,1] <- mean(cs.eas50[[ii]][1:10,2])
            summary.cs.eas50[ii,2] <- mean(cs.eas50[[ii]][11:20,2])
            summary.cs.eas50[ii,3] <- mean(cs.eas50[[ii]][21:30,2])
            summary.cs.afr50[ii,1] <- mean(cs.afr50[[ii]][1:10,2])
            summary.cs.afr50[ii,2] <- mean(cs.afr50[[ii]][11:20,2])
            summary.cs.afr50[ii,3] <- mean(cs.afr50[[ii]][21:30,2])
    }
}
colnames(summary.cs.eas50) <- c('1%','5%','10%')
rownames(summary.cs.eas50) <- analysis
colnames(summary.cs.afr50) <- c('1%','5%','10%')
rownames(summary.cs.afr50) <- analysis

csx.afr50 <- list()
csx.eas50 <- list()
summary.csx.afr50 <- matrix(ncol=3,nrow=2)
summary.csx.eas50 <- matrix(ncol=3,nrow=2)
for( j in 1:1 ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
            csx.eas50[[ii]] <- read.table(paste0('csx_res50/eas_20k',
                                              causal[k],'.dat'))
            csx.afr50[[ii]] <- read.table(paste0('csx_res50/afr_20k',
                                              causal[k],'.dat'))
            csx.eas50[[ii]] <-  csx.eas50[[ii]][order(csx.eas50[[ii]]$V1,decreasing=FALSE),]
            csx.afr50[[ii]] <-  csx.afr50[[ii]][order(csx.afr50[[ii]]$V1,decreasing=FALSE),]
            summary.csx.eas50[ii,1] <- mean(csx.eas50[[ii]][1:10,2])
            summary.csx.eas50[ii,2] <- mean(csx.eas50[[ii]][11:20,2])
            summary.csx.eas50[ii,3] <- mean(csx.eas50[[ii]][21:30,2])
            summary.csx.afr50[ii,1] <- mean(csx.afr50[[ii]][1:10,2])
            summary.csx.afr50[ii,2] <- mean(csx.afr50[[ii]][11:20,2])
            summary.csx.afr50[ii,3] <- mean(csx.afr50[[ii]][21:30,2])
    }
}
colnames(summary.csx.eas50) <- c('1%','5%','10%')
rownames(summary.csx.eas50) <- analysis
colnames(summary.csx.afr50) <- c('1%','5%','10%')
rownames(summary.csx.afr50) <- analysis

##################
# 75% heritability
##################
prsice.afr75 <- list()
prsice.eas75 <- list()
summary.prsice.afr75 <- matrix(ncol=3,nrow=2)
summary.prsice.eas75 <- matrix(ncol=3,nrow=2)
for( j in 1:1 ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
        prsice.eas75[[ii]] <- read.table(paste0('prsice_res75/eas_',
                                               size[j],causal[k],'.dat'))
        prsice.afr75[[ii]] <- read.table(paste0('prsice_res75/afr_',
                                              size[j],causal[k],'.dat'))
        prsice.eas75[[ii]] <-  prsice.eas75[[ii]][order(prsice.eas75[[ii]]$V1,decreasing=FALSE),]
        prsice.afr75[[ii]] <-  prsice.afr75[[ii]][order(prsice.afr75[[ii]]$V1,decreasing=FALSE),]
        summary.prsice.eas75[ii,1] <- mean(prsice.eas75[[ii]][1:10,2])
        summary.prsice.eas75[ii,2] <- mean(prsice.eas75[[ii]][11:20,2])
        summary.prsice.eas75[ii,3] <- mean(prsice.eas75[[ii]][21:30,2])
        summary.prsice.afr75[ii,1] <- mean(prsice.afr75[[ii]][1:10,2])
        summary.prsice.afr75[ii,2] <- mean(prsice.afr75[[ii]][11:20,2])
        summary.prsice.afr75[ii,3] <- mean(prsice.afr75[[ii]][21:30,2])
    }
}
colnames(summary.prsice.eas75) <- c('1%','5%','10%')
rownames(summary.prsice.eas75) <- analysis
colnames(summary.prsice.afr75) <- c('1%','5%','10%')
rownames(summary.prsice.afr75) <- analysis

ridge.afr75 <- list()
ridge.eas75 <- list()
summary.ridge.afr75 <- matrix(ncol=3,nrow=2)
summary.ridge.eas75 <- matrix(ncol=3,nrow=2)
for( j in 1:length(size) ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
        ridge.eas75[[ii]] <- read.table(paste0('ridge_res75/eas_',
                                             size[j],causal[k],'.dat'))
        ridge.afr75[[ii]] <- read.table(paste0('ridge_res75/afr_',
                                             size[j],causal[k],'.dat'))
        summary.ridge.eas75[ii,1] <- mean(ridge.eas75[[ii]][1:10,1])
        summary.ridge.eas75[ii,2] <- mean(ridge.eas75[[ii]][11:20,1])
        summary.ridge.eas75[ii,3] <- mean(ridge.eas75[[ii]][21:30,1])
        summary.ridge.afr75[ii,1] <- mean(ridge.afr75[[ii]][1:10,1])
        summary.ridge.afr75[ii,2] <- mean(ridge.afr75[[ii]][11:20,1])
        summary.ridge.afr75[ii,3] <- mean(ridge.afr75[[ii]][21:30,1])
    }
}
colnames(summary.ridge.eas75) <- c('1%','5%','10%')
rownames(summary.ridge.eas75) <- analysis
colnames(summary.ridge.afr75) <- c('1%','5%','10%')
rownames(summary.ridge.afr75) <- analysis

cs.afr75 <- list()
cs.eas75 <- list()
summary.cs.afr75 <- matrix(ncol=3,nrow=2)
summary.cs.eas75 <- matrix(ncol=3,nrow=2)
for( j in 1:1 ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
            cs.eas75[[ii]] <- read.table(paste0('cs_res75/eas_',
                                              size[j],causal[k],'.dat'))
            cs.afr75[[ii]] <- read.table(paste0('cs_res75/afr_',
                                              size[j],causal[k],'.dat'))
            cs.eas75[[ii]] <-  cs.eas75[[ii]][order(cs.eas75[[ii]]$V1,decreasing=FALSE),]
            cs.afr75[[ii]] <-  cs.afr75[[ii]][order(cs.afr75[[ii]]$V1,decreasing=FALSE),]
            summary.cs.eas75[ii,1] <- mean(cs.eas75[[ii]][1:10,2])
            summary.cs.eas75[ii,2] <- mean(cs.eas75[[ii]][11:20,2])
            summary.cs.eas75[ii,3] <- mean(cs.eas75[[ii]][21:30,2])
            summary.cs.afr75[ii,1] <- mean(cs.afr75[[ii]][1:10,2])
            summary.cs.afr75[ii,2] <- mean(cs.afr75[[ii]][11:20,2])
            summary.cs.afr75[ii,3] <- mean(cs.afr75[[ii]][21:30,2])
    }
}
colnames(summary.cs.eas75) <- c('1%','5%','10%')
rownames(summary.cs.eas75) <- analysis
colnames(summary.cs.afr75) <- c('1%','5%','10%')
rownames(summary.cs.afr75) <- analysis

csx.afr75 <- list()
csx.eas75 <- list()
summary.csx.afr75 <- matrix(ncol=3,nrow=2)
summary.csx.eas75 <- matrix(ncol=3,nrow=2)
for( j in 1:1 ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
            csx.eas75[[ii]] <- read.table(paste0('csx_res75/eas_20k',
                                              causal[k],'.dat'))
            csx.afr75[[ii]] <- read.table(paste0('csx_res75/afr_20k',
                                              causal[k],'.dat'))
            csx.eas75[[ii]] <-  csx.eas75[[ii]][order(csx.eas75[[ii]]$V1,decreasing=FALSE),]
            csx.afr75[[ii]] <-  csx.afr75[[ii]][order(csx.afr75[[ii]]$V1,decreasing=FALSE),]
            summary.csx.eas75[ii,1] <- mean(csx.eas75[[ii]][1:10,2])
            summary.csx.eas75[ii,2] <- mean(csx.eas75[[ii]][11:20,2])
            summary.csx.eas75[ii,3] <- mean(csx.eas75[[ii]][21:30,2])
            summary.csx.afr75[ii,1] <- mean(csx.afr75[[ii]][1:10,2])
            summary.csx.afr75[ii,2] <- mean(csx.afr75[[ii]][11:20,2])
            summary.csx.afr75[ii,3] <- mean(csx.afr75[[ii]][21:30,2])
    }
}
colnames(summary.csx.eas75) <- c('1%','5%','10%')
rownames(summary.csx.eas75) <- analysis
colnames(summary.csx.afr75) <- c('1%','5%','10%')
rownames(summary.csx.afr75) <- analysis

##################
# half n 25% heritability
##################
prsice.afr.half.n <- list()
prsice.eas.half.n <- list()
summary.prsice.afr.half.n <- matrix(ncol=3,nrow=2)
summary.prsice.eas.half.n <- matrix(ncol=3,nrow=2)
for( j in 1:1 ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
        prsice.eas.half.n[[ii]] <- read.table(paste0('prsice_res_half_n/eas_',
                                               size[j],causal[k],'.dat'))
        prsice.afr.half.n[[ii]] <- read.table(paste0('prsice_res_half_n/afr_',
                                              size[j],causal[k],'.dat'))
        prsice.eas.half.n[[ii]] <-  prsice.eas.half.n[[ii]][order(prsice.eas.half.n[[ii]]$V1,decreasing=FALSE),]
        prsice.afr.half.n[[ii]] <-  prsice.afr.half.n[[ii]][order(prsice.afr.half.n[[ii]]$V1,decreasing=FALSE),]
        summary.prsice.eas.half.n[ii,1] <- mean(prsice.eas.half.n[[ii]][1:10,2])
        summary.prsice.eas.half.n[ii,2] <- mean(prsice.eas.half.n[[ii]][11:20,2])
        summary.prsice.eas.half.n[ii,3] <- mean(prsice.eas.half.n[[ii]][21:30,2])
        summary.prsice.afr.half.n[ii,1] <- mean(prsice.afr.half.n[[ii]][1:10,2])
        summary.prsice.afr.half.n[ii,2] <- mean(prsice.afr.half.n[[ii]][11:20,2])
        summary.prsice.afr.half.n[ii,3] <- mean(prsice.afr.half.n[[ii]][21:30,2])
    }
}
colnames(summary.prsice.eas.half.n) <- c('1%','5%','10%')
rownames(summary.prsice.eas.half.n) <- analysis
colnames(summary.prsice.afr.half.n) <- c('1%','5%','10%')
rownames(summary.prsice.afr.half.n) <- analysis

ridge.afr.half.n <- list()
ridge.eas.half.n <- list()
summary.ridge.afr.half.n <- matrix(ncol=3,nrow=2)
summary.ridge.eas.half.n <- matrix(ncol=3,nrow=2)
for( j in 1:length(size) ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
        ridge.eas.half.n[[ii]] <- read.table(paste0('ridge_res_half_n/eas_',
                                             size[j],causal[k],'.dat'))
        ridge.afr.half.n[[ii]] <- read.table(paste0('ridge_res_half_n/afr_',
                                             size[j],causal[k],'.dat'))
        summary.ridge.eas.half.n[ii,1] <- mean(ridge.eas.half.n[[ii]][1:10,1])
        summary.ridge.eas.half.n[ii,2] <- mean(ridge.eas.half.n[[ii]][11:20,1])
        summary.ridge.eas.half.n[ii,3] <- mean(ridge.eas.half.n[[ii]][21:30,1])
        summary.ridge.afr.half.n[ii,1] <- mean(ridge.afr.half.n[[ii]][1:10,1])
        summary.ridge.afr.half.n[ii,2] <- mean(ridge.afr.half.n[[ii]][11:20,1])
        summary.ridge.afr.half.n[ii,3] <- mean(ridge.afr.half.n[[ii]][21:30,1])
    }
}
colnames(summary.ridge.eas.half.n) <- c('1%','5%','10%')
rownames(summary.ridge.eas.half.n) <- analysis
colnames(summary.ridge.afr.half.n) <- c('1%','5%','10%')
rownames(summary.ridge.afr.half.n) <- analysis

cs.afr.half.n <- list()
cs.eas.half.n <- list()
summary.cs.afr.half.n <- matrix(ncol=3,nrow=2)
summary.cs.eas.half.n <- matrix(ncol=3,nrow=2)
for( j in 1:1 ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
            cs.eas.half.n[[ii]] <- read.table(paste0('cs_res_half_n/eas_',
                                              size[j],causal[k],'.dat'))
            cs.afr.half.n[[ii]] <- read.table(paste0('cs_res_half_n/afr_',
                                              size[j],causal[k],'.dat'))
            cs.eas.half.n[[ii]] <-  cs.eas.half.n[[ii]][order(cs.eas.half.n[[ii]]$V1,decreasing=FALSE),]
            cs.afr.half.n[[ii]] <-  cs.afr.half.n[[ii]][order(cs.afr.half.n[[ii]]$V1,decreasing=FALSE),]
            summary.cs.eas.half.n[ii,1] <- mean(cs.eas.half.n[[ii]][1:10,2])
            summary.cs.eas.half.n[ii,2] <- mean(cs.eas.half.n[[ii]][11:20,2])
            summary.cs.eas.half.n[ii,3] <- mean(cs.eas.half.n[[ii]][21:30,2])
            summary.cs.afr.half.n[ii,1] <- mean(cs.afr.half.n[[ii]][1:10,2])
            summary.cs.afr.half.n[ii,2] <- mean(cs.afr.half.n[[ii]][11:20,2])
            summary.cs.afr.half.n[ii,3] <- mean(cs.afr.half.n[[ii]][21:30,2])
    }
}
colnames(summary.cs.eas.half.n) <- c('1%','5%','10%')
rownames(summary.cs.eas.half.n) <- analysis
colnames(summary.cs.afr.half.n) <- c('1%','5%','10%')
rownames(summary.cs.afr.half.n) <- analysis

csx.afr.half.n <- list()
csx.eas.half.n <- list()
summary.csx.afr.half.n <- matrix(ncol=3,nrow=2)
summary.csx.eas.half.n <- matrix(ncol=3,nrow=2)
for( j in 1:1 ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
            csx.eas.half.n[[ii]] <- read.table(paste0('csx_res_half_n/eas_20k',
                                              causal[k],'.dat'))
            csx.afr.half.n[[ii]] <- read.table(paste0('csx_res_half_n/afr_20k',
                                              causal[k],'.dat'))
            csx.eas.half.n[[ii]] <-  csx.eas.half.n[[ii]][order(csx.eas.half.n[[ii]]$V1,decreasing=FALSE),]
            csx.afr.half.n[[ii]] <-  csx.afr.half.n[[ii]][order(csx.afr.half.n[[ii]]$V1,decreasing=FALSE),]
            summary.csx.eas.half.n[ii,1] <- mean(csx.eas.half.n[[ii]][1:10,2])
            summary.csx.eas.half.n[ii,2] <- mean(csx.eas.half.n[[ii]][11:20,2])
            summary.csx.eas.half.n[ii,3] <- mean(csx.eas.half.n[[ii]][21:30,2])
            summary.csx.afr.half.n[ii,1] <- mean(csx.afr.half.n[[ii]][1:10,2])
            summary.csx.afr.half.n[ii,2] <- mean(csx.afr.half.n[[ii]][11:20,2])
            summary.csx.afr.half.n[ii,3] <- mean(csx.afr.half.n[[ii]][21:30,2])
    }
}
colnames(summary.csx.eas.half.n) <- c('1%','5%','10%')
rownames(summary.csx.eas.half.n) <- analysis
colnames(summary.csx.afr.half.n) <- c('1%','5%','10%')
rownames(summary.csx.afr.half.n) <- analysis

##################
# half n 50% heritability
##################
prsice.afr50.half.n <- list()
prsice.eas50.half.n <- list()
summary.prsice.afr50.half.n <- matrix(ncol=3,nrow=2)
summary.prsice.eas50.half.n <- matrix(ncol=3,nrow=2)
for( j in 1:1 ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
        prsice.eas50.half.n[[ii]] <- read.table(paste0('prsice_res50_half_n/eas_',
                                               size[j],causal[k],'.dat'))
        prsice.afr50.half.n[[ii]] <- read.table(paste0('prsice_res50_half_n/afr_',
                                              size[j],causal[k],'.dat'))
        prsice.eas50.half.n[[ii]] <-  prsice.eas50.half.n[[ii]][order(prsice.eas50.half.n[[ii]]$V1,decreasing=FALSE),]
        prsice.afr50.half.n[[ii]] <-  prsice.afr50.half.n[[ii]][order(prsice.afr50.half.n[[ii]]$V1,decreasing=FALSE),]
        summary.prsice.eas50.half.n[ii,1] <- mean(prsice.eas50.half.n[[ii]][1:10,2])
        summary.prsice.eas50.half.n[ii,2] <- mean(prsice.eas50.half.n[[ii]][11:20,2])
        summary.prsice.eas50.half.n[ii,3] <- mean(prsice.eas50.half.n[[ii]][21:30,2])
        summary.prsice.afr50.half.n[ii,1] <- mean(prsice.afr50.half.n[[ii]][1:10,2])
        summary.prsice.afr50.half.n[ii,2] <- mean(prsice.afr50.half.n[[ii]][11:20,2])
        summary.prsice.afr50.half.n[ii,3] <- mean(prsice.afr50.half.n[[ii]][21:30,2])
    }
}
colnames(summary.prsice.eas50.half.n) <- c('1%','5%','10%')
rownames(summary.prsice.eas50.half.n) <- analysis
colnames(summary.prsice.afr50.half.n) <- c('1%','5%','10%')
rownames(summary.prsice.afr50.half.n) <- analysis

ridge.afr50.half.n <- list()
ridge.eas50.half.n <- list()
summary.ridge.afr50.half.n <- matrix(ncol=3,nrow=2)
summary.ridge.eas50.half.n <- matrix(ncol=3,nrow=2)
for( j in 1:length(size) ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
        ridge.eas50.half.n[[ii]] <- read.table(paste0('ridge_res50_half_n/eas_',
                                             size[j],causal[k],'.dat'))
        ridge.afr50.half.n[[ii]] <- read.table(paste0('ridge_res50_half_n/afr_',
                                             size[j],causal[k],'.dat'))
        summary.ridge.eas50.half.n[ii,1] <- mean(ridge.eas50.half.n[[ii]][1:10,1])
        summary.ridge.eas50.half.n[ii,2] <- mean(ridge.eas50.half.n[[ii]][11:20,1])
        summary.ridge.eas50.half.n[ii,3] <- mean(ridge.eas50.half.n[[ii]][21:30,1])
        summary.ridge.afr50.half.n[ii,1] <- mean(ridge.afr50.half.n[[ii]][1:10,1])
        summary.ridge.afr50.half.n[ii,2] <- mean(ridge.afr50.half.n[[ii]][11:20,1])
        summary.ridge.afr50.half.n[ii,3] <- mean(ridge.afr50.half.n[[ii]][21:30,1])
    }
}
colnames(summary.ridge.eas50.half.n) <- c('1%','5%','10%')
rownames(summary.ridge.eas50.half.n) <- analysis
colnames(summary.ridge.afr50.half.n) <- c('1%','5%','10%')
rownames(summary.ridge.afr50.half.n) <- analysis

cs.afr50.half.n <- list()
cs.eas50.half.n <- list()
summary.cs.afr50.half.n <- matrix(ncol=3,nrow=2)
summary.cs.eas50.half.n <- matrix(ncol=3,nrow=2)
for( j in 1:1 ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
            cs.eas50.half.n[[ii]] <- read.table(paste0('cs_res50_half_n/eas_',
                                              size[j],causal[k],'.dat'))
            cs.afr50.half.n[[ii]] <- read.table(paste0('cs_res50_half_n/afr_',
                                              size[j],causal[k],'.dat'))
            cs.eas50.half.n[[ii]] <-  cs.eas50.half.n[[ii]][order(cs.eas50.half.n[[ii]]$V1,decreasing=FALSE),]
            cs.afr50.half.n[[ii]] <-  cs.afr50.half.n[[ii]][order(cs.afr50.half.n[[ii]]$V1,decreasing=FALSE),]
            summary.cs.eas50.half.n[ii,1] <- mean(cs.eas50.half.n[[ii]][1:10,2])
            summary.cs.eas50.half.n[ii,2] <- mean(cs.eas50.half.n[[ii]][11:20,2])
            summary.cs.eas50.half.n[ii,3] <- mean(cs.eas50.half.n[[ii]][21:30,2])
            summary.cs.afr50.half.n[ii,1] <- mean(cs.afr50.half.n[[ii]][1:10,2])
            summary.cs.afr50.half.n[ii,2] <- mean(cs.afr50.half.n[[ii]][11:20,2])
            summary.cs.afr50.half.n[ii,3] <- mean(cs.afr50.half.n[[ii]][21:30,2])
    }
}
colnames(summary.cs.eas50.half.n) <- c('1%','5%','10%')
rownames(summary.cs.eas50.half.n) <- analysis
colnames(summary.cs.afr50.half.n) <- c('1%','5%','10%')
rownames(summary.cs.afr50.half.n) <- analysis

csx.afr50.half.n <- list()
csx.eas50.half.n <- list()
summary.csx.afr50.half.n <- matrix(ncol=3,nrow=2)
summary.csx.eas50.half.n <- matrix(ncol=3,nrow=2)
for( j in 1:1 ){
    for( k in 1:2 ){
        ii <- (j-1)*2 + k
            csx.eas50.half.n[[ii]] <- read.table(paste0('csx_res50_half_n/eas_20k',
                                              causal[k],'.dat'))
            csx.afr50.half.n[[ii]] <- read.table(paste0('csx_res50_half_n/afr_20k',
                                              causal[k],'.dat'))
            csx.eas50.half.n[[ii]] <-  csx.eas50.half.n[[ii]][order(csx.eas50.half.n[[ii]]$V1,decreasing=FALSE),]
            csx.afr50.half.n[[ii]] <-  csx.afr50.half.n[[ii]][order(csx.afr50.half.n[[ii]]$V1,decreasing=FALSE),]
            summary.csx.eas50.half.n[ii,1] <- mean(csx.eas50.half.n[[ii]][1:10,2])
            summary.csx.eas50.half.n[ii,2] <- mean(csx.eas50.half.n[[ii]][11:20,2])
            summary.csx.eas50.half.n[ii,3] <- mean(csx.eas50.half.n[[ii]][21:30,2])
            summary.csx.afr50.half.n[ii,1] <- mean(csx.afr50.half.n[[ii]][1:10,2])
            summary.csx.afr50.half.n[ii,2] <- mean(csx.afr50.half.n[[ii]][11:20,2])
            summary.csx.afr50.half.n[ii,3] <- mean(csx.afr50.half.n[[ii]][21:30,2])
    }
}
colnames(summary.csx.eas50.half.n) <- c('1%','5%','10%')
rownames(summary.csx.eas50.half.n) <- analysis
colnames(summary.csx.afr50.half.n) <- c('1%','5%','10%')
rownames(summary.csx.afr50.half.n) <- analysis

