library(data.table)
library(boot)
var.explained <- function(data,ptr){
    ptr.PRS <- grep('PRS',colnames(data))
    fit0 <- summary(lm( data$y ~ 1, subset=ptr ))
    fit1 <- summary(lm( data$y ~ as.matrix(data[,ptr.PRS]), subset=ptr ))
    R2 <- 1 - (1-fit1$adj.r.squared) / (1-fit0$adj.r.squared)
    return(R2)
}

index <- matrix(ncol=3,nrow=0)
for( i in 1:2 ){#causal
    for( j in 1:2 ){#pop
            for( k in 1:30 ){
                index <- rbind( index, c( i, j, k ) )
            }
    }
}

args <- commandArgs(trailingOnly=TRUE)
herit <- as.numeric(args[1])

causal_list <- c('with_causal', 'wo_causal')
pops <- c('eas', 'afr')
#sizes <- c('10k', '5k')

for( ptr in 1:120 ){
pop <- pops[index[ptr,2]]
#size <- sizes[index[ptr,4]]
causal <- causal_list[index[ptr,1]]
pheno <- paste0('SCORE',index[ptr,3],'_AVG')
size <- '20k'

dir="/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen"

if( herit==25 ){
    cs.dir <- paste0(dir,'/cs/',pop,'.',pheno,'.',size,'.',causal)
    cs.dir.eur <- paste0(dir,'/cs/eur.',pheno,'.80k.',causal)
    outdir="cs_res/"
    dir="/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/scores/"
}
if( herit==50 ){
    cs.dir <- paste0(dir,'/cs50/',pop,'.',pheno,'.',size,'.',causal)
    cs.dir.eur <- paste0(dir,'/cs50/eur.',pheno,'.80k.',causal)
    outdir="cs_res50/"
    dir="/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/scores50/"
}

pheno.test <- fread(paste0(dir,pheno,'_',pop,'_test.dat'))
pheno.valid <- fread(paste0(dir,pheno,'_',pop,'_valid.dat'))

tmp <- fread(paste0(cs.dir,'/scores_',pop,'_chr1.sscore'))
pred1 <- data.frame( tmp$IID, tmp$SCORE1_AVG*tmp$ALLELE_CT )
tmp <- fread(paste0(cs.dir.eur,'/scores_',pop,'_chr1.sscore'))
pred2 <- data.frame( tmp$IID, tmp$SCORE1_AVG*tmp$ALLELE_CT )
for( chr in 2:22 ){
    tmp <- fread(paste0(cs.dir,'/scores_',pop,'_chr',chr,'.sscore'))
    pred1[,2] <- pred1[,2] + tmp$SCORE1_AVG * tmp$ALLELE_CT
    tmp <- fread(paste0(cs.dir.eur,'/scores_',pop,'_chr',chr,'.sscore'))
    pred2[,2] <- pred2[,2] + tmp$SCORE1_AVG * tmp$ALLELE_CT
}
colnames(pred1) <- c("id","prs")
colnames(pred2) <- c("id","prs")
ptr.test <- match( pheno.test$IID, pred1$id )
ptr.valid <- match( pheno.valid$IID, pred1$id )
fit <- lm( pheno.test$SCORE ~ pred1$prs[ptr.test] + pred2$prs[ptr.test] )

G <- cbind( 1, pred1$prs[ptr.valid], pred2$prs[ptr.valid] )
PRS  <- G %*% fit$coefficients

print(sum(PRS))

data <- data.frame( pheno.valid$SCORE, PRS )
colnames(data)[1:2] <- c('y','PRS')
b <- boot(data,var.explained,stype="i",
          R=10000,parallel='multicore',ncpus=50)
ci <- boot.ci(b,type='norm')
var.exp <- c( index[ptr,3], b$t0, ci$normal[2:3] )

write.table(t(var.exp), append=TRUE,
            paste0('/hpc/users/hoggac01/1000G/',outdir,pop,'_',size,'.',causal,'.dat'),
            quote=FALSE,row.names=FALSE,col.names=FALSE)
}
