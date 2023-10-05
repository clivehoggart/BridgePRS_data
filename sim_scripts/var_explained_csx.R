library(data.table)
library(boot)
var.explained <- function(data,ptr){
    ptr.PRS <- grep('PRS',colnames(data))
    fit0 <- summary(lm( data$y ~ 1, subset=ptr ))
    fit1 <- summary(lm( data$y ~ as.matrix(data[,ptr.PRS]), subset=ptr ))
    R2 <- 1 - (1-fit1$adj.r.squared) / (1-fit0$adj.r.squared)
    return(R2)
}

args <- commandArgs(trailingOnly=TRUE)
ptr <- as.numeric(args[1])
herit <- as.character(args[2])
panel<- as.character(args[3])

index <- matrix(ncol=3,nrow=0)
for( i in 1:2 ){#causal
    for( j in 1:2 ){#pop
            for( k in 1:30 ){
                index <- rbind( index, c( i, j, k ) )
            }
    }
}

causal_list <- c('WITHcausal','NOcausal')
pops <- c('EAS','AFR')
pops1 <- c('eas','afr')

pop <- pops[index[ptr,2]]
pop1 <- pops1[index[ptr,2]]
causal <- causal_list[index[ptr,1]]
i <- index[ptr,3]

if( panel=="1000G" & herit=="75" ){
    dir.csx="/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/csx75/"
    outdir="csx_res75/"
    ext=".dat"
    dir="/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/scores75/"
}
if( panel=="1000G" & herit=="50" ){
    dir.csx="/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/csx50/"
    outdir="csx_res50/"
    ext=".dat"
    dir="/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/scores50/"
}
if( panel=="1000G" & herit=="25" ){
    dir.csx="/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/csx25/"
    outdir="csx_res25/"
    ext=".dat"
    dir="/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/scores/"
}
if( panel=="1000G" & herit=="half_n" ){
    dir.csx="/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/csx_half_n/"
    outdir="csx_res_half_n/"
    ext=".dat"
    dir="/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/scores_half_n/"
}
if( panel=="ukb" & herit=="25" ){
    dir.csx="/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/csx25.ukb/"
    outdir="csx_res25_ukb/"
    ext="_ukb.dat"
    dir="/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/scores/"
}

prs <- fread(paste0(dir.csx,causal,"/",
                    "/SCORE",i,"/result/validate/",
                    pop,"-SCORE",i,"_AVG.validate.score"))
pheno <- fread(paste0(dir,'SCORE',i,'_AVG_',pop1,
                      '_valid.dat'))
prs <- prs[match( pheno$IID, prs$IID ),]
data <- data.frame( pheno$SCORE, prs$Score )
colnames(data)[1:2] <- c('y','PRS')
b <- boot(data,var.explained,stype="i",
          R=10000,parallel='multicore',ncpus=50)
ci <- boot.ci(b,type='norm')
var.exp <- c( index[ptr,3], b$t0, ci$normal[2:3] )

size <- '20k'
write.table(t(var.exp), append=TRUE,
            paste0('/hpc/users/hoggac01/1000G/',outdir,pop1,'_',size,'.',causal,ext),
            quote=FALSE,row.names=FALSE,col.names=FALSE)

