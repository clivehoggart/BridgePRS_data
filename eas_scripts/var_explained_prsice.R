library(data.table)
library(boot)
var.explained <- function(data,ptr){
    ptr.PRS <- grep('PRS',colnames(data))
    fit0 <- summary(lm( data$y ~ 1, subset=ptr ))
    fit1 <- summary(lm( data$y ~ as.matrix(data[,ptr.PRS]), subset=ptr ))
    R2 <- 1 - (1-fit1$adj.r.squared) / (1-fit0$adj.r.squared)
    return(R2)
}

phenos <- c( 50,     21001, 30610, 30220, 30710, 30150,  30780, 30040, 30130, 30140,  30080, 30870, 30860)
phenos2 <- c('Height', 'BMI',   'ALP',   'Baso',  'CRP',   'Eosino', 'LDL-C', 'MCV',   'Mono',  'Neutro', 'Plt',   'TG',    'TP')

args <- commandArgs(trailingOnly=TRUE)
i <- as.numeric(args[1])

dir1 <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ/prsice/"
dir2 <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/"

prs1 <- fread(paste0(dir1,phenos2[i],'_EUR.best'))
prs2 <- fread(paste0(dir1,phenos2[i],'_EAS.best'))
pheno.test <- fread(paste0(dir2,phenos[i],'/EAS-',phenos[i],'-test.dat'))
pheno.valid <- fread(paste0(dir2,phenos[i],'/EAS-',phenos[i],'-valid.dat'))

pheno <- rbind( pheno.test, pheno.valid )
prs1 <- prs1[match( pheno$IID, prs1$IID ),]
prs2 <- prs2[match( pheno$IID, prs2$IID ),]
ptr.test <- match( pheno.test$IID, pheno$IID )
ptr.valid <- match( pheno.valid$IID, pheno$IID )

data1 <- data.frame( pheno$Phenotype, prs1$PRS )
colnames(data1)[1:2] <- c('y','PRS')
R2.1 <- var.explained( data1, ptr.test )

data2 <- data.frame( pheno$Phenotype, prs2$PRS )
colnames(data2)[1:2] <- c('y','PRS')
R2.2 <- var.explained( data2, ptr.test )

if( R2.1 > R2.2 ){
    data <- data1[ptr.valid,]
    ld.panel <- 'eur'
}else{
    data <- data2[ptr.valid,]
    ld.panel <- 'eas'
}

b <- boot(data,var.explained,stype="i",
          R=10000,parallel='multicore',ncpus=50)
ci <- boot.ci(b,type='norm')

prsice <- c( phenos[i], b$t0, ci$normal[2:3], ld.panel )

write.table(t(prsice), append=TRUE,
            paste0('~/ukb/prsice_res/EAS_imputed.dat'),
            quote=FALSE,row.names=FALSE,col.names=FALSE)

