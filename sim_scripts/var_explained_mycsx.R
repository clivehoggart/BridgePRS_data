library(data.table)
library(boot)
var.explained <- function(data,ptr){
    ptr.PRS <- grep('PRS',colnames(data))
    fit0 <- summary(lm( data$y ~ 1, subset=ptr ))
    fit1 <- summary(lm( data$y ~ as.matrix(data[,ptr.PRS]), subset=ptr ))
    R2 <- 1 - (1-fit1$adj.r.squared) / (1-fit0$adj.r.squared)
    return(R2)
}

causal_list <- c('.with_causal', '.wo_causal')
pops <- c('eas', 'afr')

index <- matrix(ncol=3,nrow=0)
for( i in 1:2 ){#causal
    for( j in 1:2 ){#pop
            for( k in 1:30 ){
                index <- rbind( index, c( i, j, k ) )
            }
    }
}

args <- commandArgs(trailingOnly=TRUE)
ptr <- as.numeric(args[1])
analysis <- args[2]

pop <- pops[index[ptr,2]]
causal <- causal_list[index[ptr,1]]
ii <- index[ptr,3]

pheno <- paste0('SCORE',ii,'_AVG')

if( analysis=="25" ){
    dir="/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/scores/"
    cs.dir <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/csx25/"
    outdir="csx_res25/"
}
if( analysis=="50" ){
    dir="/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/scores50/"
    cs.dir <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/csx50/"
    outdir="csx_res50/"
}
if( analysis=="75" ){
    dir="/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/scores75/"
    cs.dir <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/csx75/"
    outdir="csx_res75/"
}
if( analysis=="half_n" ){
    dir="/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/scores_half_n/"
    cs.dir="/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/csx_half_n/"
    outdir="csx_res_half_n/"
}
if( analysis=="50_half_n" ){
    dir="/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/scores50_half_n/"
    cs.dir="/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/csx50_half_n/"
    outdir="csx_res50_half_n/"
}
if( analysis=="ukb" ){
    dir="/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/scores/"
    cs.dir <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/csx25.ukb/"
    outdir="csx_res25_ukb/"
}

phi <- c('1e+00', '1e-02', '1e-04', '1e-06')

pheno.test <- fread(paste0(dir,pheno,'_',pop,'_test.dat'))
pheno.valid <- fread(paste0(dir,pheno,'_',pop,'_valid.dat'))

fit <- list()
r2 <- vector()
pred1 <- list()
pred2 <- list()
for( i in 1:4 ){
    tmp <- fread(paste0(cs.dir,pheno,".",pop,causal,
                        "/scores_",pop,"_",phi[i],"_chr1.sscore"))
    pred1[[i]] <- data.frame( tmp$IID, tmp$SCORE1_AVG*tmp$ALLELE_CT )
    tmp <- fread(paste0(cs.dir,pheno,".",pop,causal,
                        "/scores_eur_",phi[i],"_chr1.sscore"))
    pred2[[i]] <- data.frame( tmp$IID, tmp$SCORE1_AVG*tmp$ALLELE_CT )
    for( chr in 2:22 ){
        tmp <- fread(paste0(cs.dir,pheno,".",pop,causal,
                            "/scores_",pop,"_",phi[i],"_chr",chr,".sscore"))
        pred1[[i]][,2] <- pred1[[i]][,2] + tmp$SCORE1_AVG * tmp$ALLELE_CT
        tmp <- fread(paste0(cs.dir,pheno,".",pop,causal,
                            "/scores_eur_",phi[i],"_chr",chr,".sscore"))
        pred2[[i]][,2] <- pred2[[i]][,2] + tmp$SCORE1_AVG * tmp$ALLELE_CT
    }
    colnames(pred1[[i]]) <- c("id","prs")
    colnames(pred2[[i]]) <- c("id","prs")
    ptr.test <- match( pheno.test$IID, pred1[[i]]$id )
    ptr.valid <- match( pheno.valid$IID, pred1[[i]]$id )
    fit[[i]] <- lm( pheno.test$SCORE ~ pred1[[i]]$prs[ptr.test] + pred2[[i]]$prs[ptr.test] )
    r2[i] <- summary(fit[[i]])$r.squared
}
s <- order(r2,decreasing=TRUE)
s1 <- s[1]
G <- cbind( 1, pred1[[s1]]$prs[ptr.valid], pred2[[s1]]$prs[ptr.valid] )
PRS  <- G %*% fit[[s1]]$coefficients

data <- data.frame( pheno.valid$SCORE, PRS )
colnames(data)[1:2] <- c('y','PRS')
b <- boot(data,var.explained,stype="i",
          R=100,parallel='multicore',ncpus=50)
b$t0

ci <- boot.ci(b,type='norm')
var.exp <- c( index[ptr,3], b$t0, ci$normal[2:3] )

size <- '20k'
write.table(t(var.exp), append=TRUE,
            paste0('/hpc/users/hoggac01/1000G/',outdir,pop,'_',size,causal,'.dat'),
            quote=FALSE,row.names=FALSE,col.names=FALSE)

