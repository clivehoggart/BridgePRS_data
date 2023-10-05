library(data.table)
library(glmnet)
library(doMC)
library(boot)

var.explained <- function(data,ptr){
    ptr.X <- grep('X',colnames(data))
    ptr.PRS <- grep('PRS',colnames(data))
    fit0 <- summary(lm( data$y ~ 0 + as.matrix(data[,ptr.X]), subset=ptr ))
    fit1 <- summary(lm( data$y ~ 0 + as.matrix(data[,ptr.X]) + as.matrix(data[,ptr.PRS]), subset=ptr ))
    R2 <- 1 - (1-fit1$adj.r.squared) / (1-fit0$adj.r.squared)
    return(R2)
}

cov.names <- "Age,Sex,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,PC11,PC12,PC13,PC14,PC15,PC16,PC17,PC18,PC19,PC20,PC21,PC22,PC23,PC24,PC25,PC26,PC27,PC28,PC29,PC30,PC31,PC32,PC33,PC34,PC35,PC36,PC37,PC38,PC39,PC40"
cov.names <- strsplit( cov.names, ',' )[[1]]
registerDoMC(cores = 30)
alpha <- 0
#res <- list()

phenos <- c(50,21001,30220,30150,30140,30130,30080,30040,30780,30610,30710,30870,30860)
blood.phenos <- c(30780,30610,30710,30870,30860)
res <- list()
for( i in 1:length(phenos) ){
    R2 <- matrix(ncol=3,nrow=9)
    pheno <- phenos[i]
    type="normal"
    if( length(intersect(pheno,blood.phenos)) == 1 ){
        type <- "bloodbc"
    }
    pred1 <- fread(paste0("/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/imputed/test11/",pheno,"/afr_sweep_all_preds_test.dat"))
    pred2 <- fread(paste0("/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/imputed/test11/",pheno,"/afr_stage2_all_preds_test.dat"))
    pred3 <- fread(paste0("/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ/test/",pheno,"/AFR_stage2_all_preds_test.dat"))
    target <- fread(paste0("/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/",pheno,"/",pheno,"-AFR-",type,"-trim.target"))

    nfolds <- ifelse( nrow(target)<2000, nrow(target), 50 )
    fit.ridge1 <- cv.glmnet( y=target$Phenotype, x=as.matrix(pred1),
                            family="gaussian",
                            alpha=alpha, parallel=TRUE, nfolds=nfolds, grouped=FALSE )
    fit.ridge2 <- cv.glmnet( y=target$Phenotype, x=as.matrix(pred2),
                            family="gaussian",
                            alpha=alpha, parallel=TRUE, nfolds=nfolds, grouped=FALSE )
    fit.ridge3 <- cv.glmnet( y=target$Phenotype, x=as.matrix(pred3),
                            family="gaussian",
                            alpha=alpha, parallel=TRUE, nfolds=nfolds, grouped=FALSE )
    fit.ridge12 <- cv.glmnet( y=target$Phenotype, x=as.matrix(cbind(pred1,pred2)),
                             family="gaussian",
                             alpha=alpha, parallel=TRUE, nfolds=nfolds, grouped=FALSE )
    fit.ridge13 <- cv.glmnet( y=target$Phenotype, x=as.matrix(cbind(pred1,pred3)),
                             family="gaussian",
                             alpha=alpha, parallel=TRUE, nfolds=nfolds, grouped=FALSE )
    fit.ridge23 <- cv.glmnet( y=target$Phenotype, x=as.matrix(cbind(pred2,pred3)),
                             family="gaussian",
                             alpha=alpha, parallel=TRUE, nfolds=nfolds, grouped=FALSE )
    fit.ridge123 <- cv.glmnet( y=target$Phenotype, x=as.matrix(cbind(pred1,pred2,pred3)),
                              family="gaussian",
                              alpha=alpha, parallel=TRUE, nfolds=nfolds, grouped=FALSE )

    pred1 <- fread(paste0("/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/imputed/test11/",pheno,"/afr_sweep_all_preds_valid.dat"))
    pred2 <- fread(paste0("/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/imputed/test11/",pheno,"/afr_stage2_all_preds_valid.dat"))
    pred3 <- fread(paste0("/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ/test/",pheno,"/AFR_stage2_all_preds_valid.dat"))
    target <- fread(paste0("/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/",pheno,"/",pheno,"-AFR-",type,"-trim.valid"), data.table=FALSE)

    prs1 <- predict( fit.ridge1, as.matrix(pred1), s='lambda.min' )
    prs2 <- predict( fit.ridge2, as.matrix(pred2), s='lambda.min' )
    prs3 <- predict( fit.ridge3, as.matrix(pred3), s='lambda.min' )
    prs12 <- predict( fit.ridge12, as.matrix(cbind(pred1,pred2)), s='lambda.min' )
    prs13 <- predict( fit.ridge13, as.matrix(cbind(pred1,pred3)), s='lambda.min' )
    prs23 <- predict( fit.ridge23, as.matrix(cbind(pred2,pred3)), s='lambda.min' )
    prs123 <- predict( fit.ridge123, as.matrix(cbind(pred1,pred2,pred3)), s='lambda.min' )

    covs <- as.matrix(cbind(1,target[,cov.names]))
    colnames(covs) <- paste('X',colnames(covs),sep='.')

    n <- fit.ridge1$glmnet.fit$nobs

    mse <- c( min(fit.ridge1$cvm), min(fit.ridge2$cvm), min(fit.ridge12$cvm) )
    logL <- -n*log(mse) / 2
    logL <- logL - min(logL)
    probM <- exp(logL) / sum(exp(logL))
    prs.weighted1 <- apply( cbind( prs1, prs2, prs12 ) %*% diag(probM), 1, sum )

    mse <- c( min(fit.ridge1$cvm), min(fit.ridge2$cvm), min(fit.ridge3$cvm),
             min(fit.ridge12$cvm), min(fit.ridge13$cvm), min(fit.ridge23$cvm),
             min(fit.ridge123$cvm) )
    logL <- -n*log(mse) / 2
    logL <- logL - min(logL)
    probM <- exp(logL) / sum(exp(logL))
    prs.weighted2 <- apply( cbind( prs1, prs2, prs3, prs12, prs13, prs23, prs123 ) %*% diag(probM), 1, sum )

    prs <- cbind( prs1, prs2, prs3, prs12, prs13, prs23, prs123,
                 prs.weighted1, prs.weighted2 )

    for( k in 1:9 ){
        data <- data.frame( target$Phenotype, prs[,k], covs )
        colnames(data)[1:2] <- c('y','PRS')
        b <- boot(data,var.explained,stype="i",R=10000,parallel='multicore',ncpus=30)
        ci <- boot.ci(b,type='norm')
        ptr.min <- which(fit.ridge1$lambda==fit.ridge1$lambda.min)
        R2[k,] <- c( b$t0, ci$normal[-1] )
    }

    res[[i]] <- cbind( R2, c(probM,0,0) )
    rownames(res[[i]]) <- c( 'R2.1', 'R2.2', 'R2.3', 'R2.12', 'R2.13', 'R2.23', 'R2.123',
                       'R2.w12', 'R2.w123' )
    print(pheno)
    print(res[[i]])
    outfile <- paste0("/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ/test/",pheno,"/AFR_weighted_combined_var_explained.txt")
}

