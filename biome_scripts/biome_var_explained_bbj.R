library(data.table)
library(boot)
source('~/bin/my_forestplot.R')

var.explained <- function( data, ptr ){
    ptr.X <- grep('X',colnames(data))
    ptr.PRS <- grep('PRS',colnames(data))
    fit0 <- summary(lm( data$y ~ as.matrix(data[,ptr.X]), subset=ptr ))
    fit1 <- summary(lm( data$y ~ as.matrix(data[,ptr.X]) + as.matrix(data[,ptr.PRS]), subset=ptr ))
    R2 <- 1 - (1-fit1$adj.r.squared) / (1-fit0$adj.r.squared)
    return(R2)
}

args <- commandArgs(trailingOnly=TRUE)
pop <- "EAS"

phenos <- c( 50 , 21001, 30780, 30040, 30080, 30130, 30140, 30150 )
pheno.nmes <- c('Height','BMI','LDL','MCV','Platelets','Mono count',
                'Neutro count','Eos count')
models <- c("_","_csx_")

my.biome.dir <- "/sc/arion/projects/rg_kennye02/hoggac01/"
bmi <- fread('/sc/arion/projects/rg_kennye02/chois26/BMI.csv')
u.id <- unique(bmi$ID_1)
bmi <- bmi[ match(u.id,bmi$ID_1), ]
ldl <- fread('/sc/arion/projects/rg_kennye02/chois26/LDL.max.csv')
height <- fread(paste0(my.biome.dir,'height.dat'))
blood <- fread(paste0(my.biome.dir,'blood.dat'))
pcs <- fread('/sc/private/regen/data/GSA_GDA/imputed_TOPMED_intermediate/addition/PC/GSA_GDA_PCA_intermediate.txt')

ptr <- match( bmi$ID_1, pcs$ID )
pcs <- pcs[ptr,]
ptr <- match( bmi$ID_1, height$ID_1 )
height <- height[ptr,]
ptr <- match( bmi$rgnid, ldl$rgnid )
ldl <- ldl[ptr,]
ptr <- match( bmi$ID_1, blood$ID_1 )
blood <- blood[ptr,]

data <- list()
data[[1]] <- data.frame( height$height, bmi$Age, height$gender, pcs[,-1] )
data[[2]] <- data.frame( bmi$BMI, bmi$Age, height$gender, pcs[,-1] )
data[[3]] <- data.frame( ldl$LDL, ldl$Age, height$gender, pcs[,-1] )
data[[4]] <- data.frame( blood$mcv, ldl$Age, height$gender, pcs[,-1] )
data[[5]] <- data.frame( log(blood$plt), ldl$Age, height$gender, pcs[,-1] )
data[[6]] <- data.frame( log(blood$mono), ldl$Age, height$gender, pcs[,-1] )
data[[7]] <- data.frame( log(blood$neutro), ldl$Age, height$gender, pcs[,-1] )
data[[8]] <- data.frame( blood$eos, ldl$Age, height$gender, pcs[,-1] )
data[[9]] <- data.frame( log(blood$rdw), ldl$Age, height$gender, pcs[,-1] )
sset <- list()
for( i in 1:length(phenos) ){
    sset[[i]] <- 1:nrow(data[[i]])
    if( i==3 ){
        sset[[i]] <- which(ldl$hasMed==0)
    }
    rownames(data[[i]]) <- bmi$rgnid
    data[[i]]$height.gender <- ifelse( data[[i]]$height.gender=="Male", 1, 0 )
    colnames(data[[i]])[-1] <- paste0("X",colnames(data[[i]])[-1])
    colnames(data[[i]])[1] <- "y"
}

r2.ci <- as.data.frame(matrix( ncol=3*length(models), nrow=length(phenos) ))
r2 <- as.data.frame(matrix( ncol=length(models), nrow=length(phenos) ))
sample.size <- vector()
for( i in 1:length(phenos) ){
    for( j in 1:length(models) ){
        print(c(i,j))
#        pred <- fread(paste0(my.biome.dir,'preds/',pop,'_',phenos[i],'_',models[j],'.sscore'))
        tmp <- fread(paste0(my.biome.dir,'preds/by_chr/',pop,'_',phenos[i],
                            models[j],'chr1.sscore'))
        pred <- data.frame( tmp$IID, tmp$SCORE1_AVG*tmp$ALLELE_CT )
        for( chr in 2:22 ){
            tmp <- fread(paste0(my.biome.dir,'preds/by_chr/',pop,'_',phenos[i],
                                models[j],'chr',chr,'.sscore'))
            pred[,2] <- pred[,2] + tmp$SCORE1_AVG * tmp$ALLELE_CT
        }
        colnames(pred) <- c("id","prs")
        ptr <- match( pred$id, rownames(data[[i]]) )
        data1 <- data.frame( pred$prs, data[[i]][ptr,] )[sset[[i]],]
        colnames(data1)[1] <- 'PRS'
        data$X.gender <- ifelse( data$X.gender=="Male", 1, 0 )
        b <- boot( data1, var.explained, stype="i", R=10000,
                  parallel='multicore', ncpus=10)
        ci <- boot.ci(b,type='norm')
        r2.ci[i,(1:3)+3*(j-1)] <- c( b$t0, ci$normal[-1] )
        r2[i,j] <- var.explained( data1, 1:nrow(data1) )
#        print(r2[i,j])
        sample.size[i] <- length(which(!is.na(apply(data1,1,sum))))
    }
}
rownames(r2) <- pheno.nmes
colnames(r2) <- models
rownames(r2.ci) <- pheno.nmes
fwrite( r2.ci, paste0("~/biome/summary_r2_pgen_",pop,".dat") )

