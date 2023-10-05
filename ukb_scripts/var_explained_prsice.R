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

phenos <- c(50, 21001, 30080, 30710, 30140, 30040, 30630, 30240, 30610, 30780, 30130, 30070, 30670, 30870, 30220, 30860, 30530, 30770, 30150)
dir1 <- c("/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/geno/phenotype/prsice/",
          "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/prsice/",
          "/sc/arion/projects/psychgen/ukb/usr/clive/ukb/impute_gwas/prsice/")

panels <- c('geno','hm','imputed')

dir2 <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/"

pop <- c('AFR','SAS')

index <- matrix(ncol=3,nrow=0)
for( j in 1:2 ){
    for( k in 1:3 ){
        for( i in 1:length(phenos) ){
            index <- rbind( index, c( j, k, i ) )
        }
    }
}

args <- commandArgs(trailingOnly=TRUE)
ptr <- as.numeric(args[1])

i <- index[ptr,3]
k <- index[ptr,2]
j <- index[ptr,1]

type <- 'normal'
cov_names=c("Age","Sex","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10","PC11","PC12","PC13","PC14","PC15","PC16","PC17","PC18","PC19","PC20","PC21","PC22","PC23","PC24","PC25","PC26","PC27","PC28","PC29","PC30","PC31","PC32","PC33","PC34","PC35","PC36","PC37","PC38","PC39","PC40")
if( phenos[i]==30780 | phenos[i]==30610 | phenos[i]==30630
   | phenos[i]==30710 | phenos[i]==30770 | phenos[i]==30650
   | phenos[i]==30810 | phenos[i]==30870 | phenos[i]==30670
   | phenos[i]==30750 | phenos[i]==30860 | phenos[i]==30890 ){
    type='bloodbc'
    cov_names=c( cov_names, "Fasting", "Dilution" )
}

prs1 <- fread(paste0(dir1[k],phenos[i],'_',pop[j],'_EUR.best'))
prs2 <- fread(paste0(dir1[k],phenos[i],'_',pop[j],'_',pop[j],'.best'))
pheno.test <- fread(paste0(dir2,phenos[i],'/',phenos[i],'-',
                           pop[j],'-',type,'-trim.target'))
pheno.valid <- fread(paste0(dir2,phenos[i],'/',phenos[i],'-',
                            pop[j],'-',type,'-trim.valid'))

pheno <- rbind( pheno.test, pheno.valid )
prs1 <- prs1[match( pheno$IID, prs1$IID ),]
prs2 <- prs2[match( pheno$IID, prs2$IID ),]
ptr.test <- match( pheno.test$IID, pheno$IID )
ptr.valid <- match( pheno.valid$IID, pheno$IID )

ptr.covs <- match( cov_names, colnames(pheno) )
covs <- as.matrix(as.data.frame(pheno)[,ptr.covs])
covs <- standardise(covs)
colnames(covs) <- paste('X',colnames(covs),sep='.')

data1 <- data.frame( pheno$Phenotype, prs1$PRS, covs )
colnames(data1)[1:2] <- c('y','PRS')
R2.1 <- var.explained( data1, ptr.test )

data2 <- data.frame( pheno$Phenotype, prs2$PRS, covs )
colnames(data2)[1:2] <- c('y','PRS')
R2.2 <- var.explained( data2, ptr.test )

if( R2.1 > R2.2 ){
    data <- data1[ptr.valid,]
    ld.panel <- 'eur'
}else{
    data <- data2[ptr.valid,]
    ld.panel <- pop[j]
}

b <- boot(data,var.explained,stype="i",
          R=10000,parallel='multicore',ncpus=50)
ci <- boot.ci(b,type='norm')

prsice <- c( phenos[i], b$t0, ci$normal[2:3], ld.panel )

write.table(t(prsice), append=TRUE,
            paste0('~/ukb/prsice_res/',pop[j],'_',panels[k],'.dat'),
            quote=FALSE,row.names=FALSE,col.names=FALSE)
