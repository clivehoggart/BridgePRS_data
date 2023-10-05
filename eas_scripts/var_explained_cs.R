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

phenos <- c( 50,     21001, 30610, 30220, 30710, 30150,  30780, 30040, 30130, 30140,  30080, 30870, 30860)
phenos2 <- c('Height', 'BMI',   'ALP',   'Baso',  'CRP',   'Eosino', 'LDL-C', 'MCV',   'Mono',  'Neutro', 'Plt',   'TG',    'TP')

pop <- 'EAS'
pop2 <- 'eas'

pheno <- phenos[ptr]
pheno2 <- phenos2[ptr]

dir <- "/sc/arion/projects/psychgen/ukb/usr/clive/BBJ/cs/"
cs.dir <- paste0(dir,pheno2)

cs.dir.eur <- paste0('/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/cs/EUR.',pheno)

outdir="cs_res/"

dir2 <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/"

type <- 'normal'
cov_names=c("Age","Sex","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10","PC11","PC12","PC13","PC14","PC15","PC16","PC17","PC18","PC19","PC20","PC21","PC22","PC23","PC24","PC25","PC26","PC27","PC28","PC29","PC30","PC31","PC32","PC33","PC34","PC35","PC36","PC37","PC38","PC39","PC40")
if( pheno==30780 | pheno==30610 | pheno==30630 | pheno==30710 | pheno==30770 | pheno==30650 | pheno==30810 | pheno==30870 | pheno==30670 | pheno==30750 | pheno==30860 | pheno==30890 ){
    type <- 'bloodbc'
    cov_names=c( cov_names, "Fasting", "Dilution" )
}

pheno.test <- fread(paste0(dir2,pheno,'/',pop,'-',pheno,'-test.dat'))
pheno.valid <- fread(paste0(dir2,pheno,'/',pop,'-',pheno,'-valid.dat'))

tmp <- fread(paste0(cs.dir,'/scores_',pop2,'_chr1.sscore'))
pred1 <- data.frame( tmp$IID, tmp$SCORE1_AVG*tmp$ALLELE_CT )
tmp <- fread(paste0(cs.dir.eur,'/scores_',pop2,'_chr1.sscore'))
pred2 <- data.frame( tmp$IID, tmp$SCORE1_AVG*tmp$ALLELE_CT )
for( chr in 2:22 ){
    tmp <- fread(paste0(cs.dir,'/scores_',pop2,'_chr',chr,'.sscore'))
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

w <- fit$coefficients[2:3]
names(w) <- c("w.eas","w.eur")
write.table(w,paste0(cs.dir,'/cs_weights.dat'))

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

#write.table(t(var.exp), append=TRUE,
#            paste0('/hpc/users/hoggac01/bbj/',outdir,pop,'.dat'),
#            quote=FALSE,row.names=FALSE,col.names=FALSE)

