library(data.table)
library(boot)
source('~/bin/functions.R')
var.explained <- function(data,ptr){
    ptr.X <- grep('X',colnames(data))
    ptr.PRS <- grep('PRS',colnames(data))
    fit0 <- summary(lm( data$y ~ as.matrix(data[,ptr.X]), subset=ptr ))
    fit1 <- summary(lm( data$y ~ as.matrix(data[,ptr.X]) + as.matrix(data[,ptr.PRS]), subset=ptr ))
    R2 <- 1 - (1-fit1$adj.r.squared) / (1-fit0$adj.r.squared)
    return(R2)
}

args <- commandArgs(trailingOnly=TRUE)
ptr <- as.numeric(args[1])

index <- matrix(ncol=2,nrow=0)
for( j in 1:2 ){#pop
    for( k in 1:19 ){
        index <- rbind( index, c( j, k ) )
    }
}

phenos <- c(50, 21001, 30080, 30710, 30140, 30040, 30630, 30240, 30610, 30780, 30130, 30070, 30670, 30870, 30220, 30860, 30530, 30770, 30150)
pops <- c('AFR','SAS')
pops2 <- c('afr','sas')

pop <- pops[index[ptr,1]]
pop2 <- pops2[index[ptr,1]]
pheno <- phenos[index[ptr,2]]

dir <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/cs/"
cs.dir <- paste0(dir,pop,'.',pheno)
cs.dir.eur <- paste0(dir,'EUR.',pheno)
outdir="cs_res/"
dir2 <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/"

type <- 'normal'
cov_names=c("Age","Sex","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10","PC11","PC12","PC13","PC14","PC15","PC16","PC17","PC18","PC19","PC20","PC21","PC22","PC23","PC24","PC25","PC26","PC27","PC28","PC29","PC30","PC31","PC32","PC33","PC34","PC35","PC36","PC37","PC38","PC39","PC40")
if( pheno==30780 | pheno==30610 | pheno==30630 | pheno==30710 | pheno==30770 | pheno==30650 | pheno==30810 | pheno==30870 | pheno==30670 | pheno==30750 | pheno==30860 | pheno==30890 ){
    type <- 'bloodbc'
    cov_names=c( cov_names, "Fasting", "Dilution" )
}

pheno.test <- fread(paste0(dir2,pheno,'/',pop,'-',pheno,'.target'))
pheno.valid <- fread(paste0(dir2,pheno,'/',pop,'-',pheno,'.valid'))

tmp <- fread(paste0(cs.dir,'/scores_',pop,'_chr1.sscore'))
pred1 <- data.frame( tmp$IID, tmp$SCORE1_AVG*tmp$ALLELE_CT )
tmp <- fread(paste0(cs.dir.eur,'/scores_',pop2,'_chr1.sscore'))
pred2 <- data.frame( tmp$IID, tmp$SCORE1_AVG*tmp$ALLELE_CT )
for( chr in 2:22 ){
    tmp <- fread(paste0(cs.dir,'/scores_',pop,'_chr',chr,'.sscore'))
    pred1[,2] <- pred1[,2] + tmp$SCORE1_AVG * tmp$ALLELE_CT
    tmp <- fread(paste0(cs.dir.eur,'/scores_',pop2,'_chr',chr,'.sscore'))
    pred2[,2] <- pred2[,2] + tmp$SCORE1_AVG * tmp$ALLELE_CT
}
colnames(pred1) <- c("id","prs")
colnames(pred2) <- c("id","prs")
ptr.test <- match( pheno.test$IID, pred1$id )
ptr.valid <- match( pheno.valid$IID, pred1$id )
ptr.covs <- match( cov_names, colnames(pheno.test) )
covs <- as.matrix(as.data.frame(pheno.test)[,ptr.covs])
covs <- standardise(covs)
fit <- lm( pheno.test$Phenotype ~ pred1$prs[ptr.test] + pred2$prs[ptr.test] + covs )

G <- cbind( 1, pred1$prs[ptr.valid], pred2$prs[ptr.valid] )
PRS  <- G %*% fit$coefficients[1:3]

covs <- as.matrix(as.data.frame(pheno.valid)[,ptr.covs])
covs <- standardise(covs)
colnames(covs) <- paste('X',colnames(covs),sep='.')
data <- data.frame( pheno.valid$Phenotype, PRS, covs )
colnames(data)[1:2] <- c('y','PRS')
b <- boot(data,var.explained,stype="i",
          R=10,parallel='multicore',ncpus=50)
ci <- boot.ci(b,type='norm')
var.exp <- c( pheno, b$t0, ci$normal[2:3] )

write.table(t(var.exp), append=TRUE,
            paste0('/hpc/users/hoggac01/ukb/',outdir,pop,'.dat'),
            quote=FALSE,row.names=FALSE,col.names=FALSE)
