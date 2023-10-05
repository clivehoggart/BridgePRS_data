library(data.table)
library(boot)
var.explained <- function(data,ptr){
    ptr.X <- grep('X',colnames(data))
    ptr.PRS <- grep('PRS',colnames(data))
    fit0 <- summary(lm( data$y ~ as.matrix(data[,ptr.X]), subset=ptr ))
    fit1 <- summary(lm( data$y ~ as.matrix(data[,ptr.X]) + as.matrix(data[,ptr.PRS]), subset=ptr ))
    R2 <- 1 - (1-fit1$adj.r.squared) / (1-fit0$adj.r.squared)
    return(R2)
}

phi <- fread("/sc/arion/projects/psychgen/ukb/usr/judit/projects/testcsx/results.txt")

pop <- "EAS"
phenos <- c(50,    21001, 30610,30220,30710,30150, 30780,30040,30130,30140, 30080,30870, 30860)

ptr.phi <- match( phenos, phi$FieldID )
Phi <- as.character(phi$Phi[ptr.phi])
Phi <- ifelse( Phi=="1e-04", "1.0E-4", Phi )
Phi <- ifelse( Phi=="1e-06", "1.0E-6", Phi )

cov.names.normal <- c("Age","Sex","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10","PC11","PC12","PC13","PC14","PC15","PC16","PC17","PC18","PC19","PC20","PC21","PC22","PC23","PC24","PC25","PC26","PC27","PC28","PC29","PC30","PC31","PC32","PC33","PC34","PC35","PC36","PC37","PC38","PC39","PC40")
cov.names.blood <- c("Age","Sex","Fasting","Dilution","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10","PC11","PC12","PC13","PC14","PC15","PC16","PC17","PC18","PC19","PC20","PC21","PC22","PC23","PC24","PC25","PC26","PC27","PC28","PC29","PC30","PC31","PC32","PC33","PC34","PC35","PC36","PC37","PC38","PC39","PC40")

stem1 <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/analysis/prscsx/bbj/"
stem1 <- "/sc/arion/projects/psychgen/ukb/usr/judit/projects/testcsx/"

stem2 <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/"

path <- "/result/validate/"

bloodbc <- c( 30780, 30610, 30630, 30710, 30770, 30650, 30810, 30870, 30670, 30750, 30860, 30890 )

res.csx <- matrix(ncol=3,nrow=length(phenos))
for( i in 1:length(phenos) ){
    print(i)

    infile <- paste0( stem1, phenos[i], path, pop, "-", phenos[i], ".validate.score" )
    infile <- paste0( stem1, phenos[i], path, pop, "-", phenos[i], "-",
                     Phi[i], ".combined.score.validate" )

    if( file.exists(infile) ){
        score <- fread(infile)
    }
    if( !file.exists(infile) ){
        print(infile)
    }

    type <- ifelse( is.na(match(phenos[i],bloodbc)), 'normal', 'bloodbc' )
    if( is.na(match(phenos[i],bloodbc)) ){
        cov.names <- cov.names.normal
    }else{
        cov.names <- cov.names.blood
    }
    infile <- paste0("/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/",phenos[i],"/EAS-",phenos[i],"-valid.dat")
    valid <- fread(infile,data.table=FALSE)

#    file <- paste0(phenos[i],'/',phenos[i],'-',pop,'-',type,'-trim.valid')
#    valid1 <- fread(paste0(stem2,file),data.table=FALSE)

    valid <- valid[match(score$IID,valid$IID),]
    covs <- valid[,cov.names]
    colnames(covs) <- paste('X',colnames(covs),sep='.')

#    data <- data.frame( valid$Phenotype, score$Score, covs )
    data <- data.frame( valid$Phenotype, score$EAS.EUR.AFR, covs )

    colnames(data)[1:2] <- c('y','PRS')
    b <- boot(data,var.explained,stype="i",R=10000,parallel='multicore',ncpus=30)
    ci <- boot.ci(b,type='norm')
    res.csx[i,] <- c(b$t0,ci$normal[-1])
}
row.names(res.csx) <- phenos
write.table( res.csx, paste0("csx_var_explained_3pop.dat"),
            quote=FALSE, col.names=FALSE )
res.csx <- res.csx[match(rownames(res.sas),rownames(res.csx)),]
