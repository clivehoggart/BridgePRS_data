library(data.table)
library(boot)
var.explained <- function(data,ptr){
    ptr.PRS <- grep('PRS',colnames(data))
    fit0 <- summary(lm( data$y ~ 1, subset=ptr ))
    fit1 <- summary(lm( data$y ~ as.matrix(data[,ptr.PRS]), subset=ptr ))
    R2 <- 1 - (1-fit1$adj.r.squared) / (1-fit0$adj.r.squared)
    return(R2)
}

args <- commandArgs(trailingOnly=TRUE)
ptr <- as.numeric(args[1])

index <- matrix(ncol=4,nrow=0)
for( i in 1:2 ){#causal
    for( j in 1:2 ){#pop
            for( k in 1:30 ){
                index <- rbind( index, c( i, j, k ) )
            }
    }
}

k <- index[ptr,1]
j <- 1
l <- index[ptr,2]
i <- index[ptr,3]

dir <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/"
size <- c('20k','10k','5k')
causal <- c('.with_causal','.wo_causal')
pop <- c('eas','afr')
pop.ld <- c('EAS.','AFR.')

prsice.afr <- list()
prsice.eas <- list()

analysis="50_half_n"
                prs1 <- fread(paste0(dir,'prsice',analysis,'/',pop.ld[l],pop[l],'.',
                                     size[j],'.SCORE',i,causal[k],'.best'))
                prs2 <- fread(paste0(dir,'prsice',analysis,'/EUR.',pop[l],'.',
                                     size[j],'.SCORE',i,causal[k],'.best'))
                pheno.test <- fread(paste0(dir,'scores',analysis,'/SCORE',i,'_AVG_',pop[l],
                                            '_valid.dat'))
                pheno.valid <- fread(paste0(dir,'scores',analysis,'/SCORE',i,'_AVG_',pop[l],
                                            '_valid.dat'))

                pheno <- rbind( pheno.test, pheno.valid )
                prs1 <- prs1[match( pheno$IID, prs1$IID ),]
                prs2 <- prs2[match( pheno$IID, prs2$IID ),]
                ptr.test <- match( pheno.test$IID, pheno$IID )
                ptr.valid <- match( pheno.valid$IID, pheno$IID )

                data1 <- data.frame( pheno$SCORE, prs1$PRS )
                colnames(data1)[1:2] <- c('y','PRS')
                R2.1 <- var.explained( data1, ptr.test )

                data2 <- data.frame( pheno$SCORE, prs2$PRS )
                colnames(data2)[1:2] <- c('y','PRS')
                R2.2 <- var.explained( data2, ptr.test )

                if( R2.1 > R2.2 ){
                    data <- data1[ptr.valid,]
                }else{
                    data <- data2[ptr.valid,]
                }

                b <- boot(data,var.explained,stype="i",R=10000,
                          parallel='multicore',ncpus=50)
                ci <- boot.ci(b,type='norm')
                var.exp <- c( i, b$t0, ci$normal[2:3] )

        write.table(t(var.exp), append=TRUE,
            paste0('/hpc/users/hoggac01/1000G/prsice_res',analysis,'/',pop[l],'_',size[j],causal[k],'.dat'),
            quote=FALSE,row.names=FALSE,col.names=FALSE)

