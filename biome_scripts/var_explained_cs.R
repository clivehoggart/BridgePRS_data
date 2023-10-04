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

phenos <- c( 50 , 21001, 30780, 30040, 30080, 30130, 30140, 30150, 30070 )
phenos.bbj <- c('Height','BMI','LDL-C','MCV','Plt'      ,'Mono'      ,'Neutro'      ,'Eosino','RDW')
pheno.nmes <- c('Height','BMI','LDL',  'MCV','Platelets','Mono count','Neutro count','Eos count','RDW')

pops <- c('AFR','SAS','EAS')

index <- matrix(ncol=2,nrow=0)
for( j in 1:3 ){#pop
    for( k in 1:8 ){
        index <- rbind( index, c( j, k ) )
    }
    if( j<3 ){
        index <- rbind( index, c( j, 9 ) )
    }
}
args <- commandArgs(trailingOnly=TRUE)
ptr <- as.numeric(args[1])
pop <- pops[index[ptr,1]]
pheno <- phenos[index[ptr,2]]
pheno.bbj <- phenos.bbj[index[ptr,2]]

if( pop!="EAS" ){
    cs.dir <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/cs/"
    w <- read.table(paste0(cs.dir,pop,'.',pheno,'/cs_weights.dat'))
}else{
    cs.dir <- "/sc/arion/projects/psychgen/ukb/usr/clive/BBJ/cs/"
    w <- read.table(paste0(cs.dir,pheno.bbj,'/cs_weights.dat'))
}

my.biome.dir <- "/sc/arion/projects/rg_kennye02/hoggac01/"
bmi <- fread('/sc/arion/projects/rg_kennye02/chois26/BMI.csv')
u.id <- unique(bmi$ID_1)
bmi <- bmi[ match(u.id,bmi$ID_1), ]
ldl <- fread('/sc/arion/projects/rg_kennye02/chois26/LDL.max.csv')
height <- fread(paste0(my.biome.dir,'height.dat'))
blood <- fread(paste0(my.biome.dir,'blood.dat'))
#pcs <- fread('/sc/private/regen/data/GSA_GDA/imputed_TOPMED_intermediate/addition/PC/GSA_GDA_PCA_intermediate.txt')

#ptr <- match( bmi$ID_1, pcs$ID )
#pcs <- pcs[ptr,]
ptr <- match( bmi$ID_1, height$ID_1 )
height <- height[ptr,]
ptr <- match( bmi$rgnid, ldl$rgnid )
ldl <- ldl[ptr,]
ptr <- match( bmi$ID_1, blood$ID_1 )
blood <- blood[ptr,]
print(c(pop,pheno,pheno.bbj))
if( pheno.bbj=="Height" ){
    data <- data.frame( height$height, bmi$Age, height$gender )
}
if( pheno.bbj=="BMI" ){
    data <- data.frame( bmi$BMI, bmi$Age, height$gender )
}
if( pheno.bbj=="LDL-C" ){
    data <- data.frame( ldl$LDL, ldl$Age, height$gender )
}
if( pheno.bbj=="MCV" ){
    data <- data.frame( blood$mcv, ldl$Age, height$gender )
}
if( pheno.bbj=="Plt" ){
    data <- data.frame( log(blood$plt), ldl$Age, height$gender )
}
if( pheno.bbj=="Mono" ){
    data <- data.frame( log(blood$mono), ldl$Age, height$gender )
}
if( pheno.bbj=="Neutro" ){
    data <- data.frame( log(blood$neutro), ldl$Age, height$gender )
}
if( pheno.bbj=="Eosino" ){
    data <- data.frame( blood$eos, ldl$Age, height$gender )
}
if( pheno==30070 ){
    data <- data.frame( log(blood$rdw), ldl$Age, height$gender )
}
rownames(data) <- bmi$rgnid
data$height.gender <- ifelse( data$height.gender=="Male", 1, 0 )
colnames(data)[-1] <- paste0("X",colnames(data)[-1])
colnames(data)[1] <- "y"

sset <- 1:nrow(data)
if( pheno.bbj=="LDL-C" ){
    sset <- which(ldl$hasMed==0)
}

#r2.ci <- as.data.frame(matrix( ncol=3, nrow=length(phenos) ))
sample.size <- vector()

tmp <- fread(paste0(my.biome.dir,'preds/by_chr/',pop,'.',pop,'_',pheno,
                    '_cs_chr1.sscore'))
pred <- data.frame( tmp$IID, tmp$SCORE1_AVG*tmp$ALLELE_CT )
tmp <- fread(paste0(my.biome.dir,'preds/by_chr/',pop,'.EUR_',pheno,
                    '_cs_chr1.sscore'))
pred2 <- data.frame( tmp$IID, tmp$SCORE1_AVG*tmp$ALLELE_CT )
for( chr in 2:22 ){
    tmp <- fread(paste0(my.biome.dir,'preds/by_chr/',pop,'.',pop,'_',pheno,
                        '_cs_chr',chr,'.sscore'))
    pred[,2] <- pred[,2] + tmp$SCORE1_AVG * tmp$ALLELE_CT
    tmp <- fread(paste0(my.biome.dir,'preds/by_chr/',pop,'.EUR_',pheno,
                        '_cs_chr',chr,'.sscore'))
    pred2[,2] <- pred2[,2] + tmp$SCORE1_AVG * tmp$ALLELE_CT
}

pred[,2] <- pred[,2]*w[1,1] + pred2[,2]*w[2,1]
colnames(pred) <- c("id","prs")

ptr <- match( pred$id, rownames(data) )
data1 <- data.frame( pred$prs, data[ptr,] )[sset,]
colnames(data1)[1] <- 'PRS'
b <- boot( data1, var.explained, stype="i", R=10000,
          parallel='multicore', ncpus=10)
ci <- boot.ci(b,type='norm')
r2.ci <- c( pheno, b$t0, ci$normal[-1] )
#print(phenos[i])
#print(r2.ci[i,])

write.table(t(r2.ci), append=TRUE,
            paste0('/hpc/users/hoggac01/biome/cs_res/',pop,'2.dat'),
            quote=FALSE,row.names=FALSE,col.names=FALSE)

