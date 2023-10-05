library(data.table)

phenos <- c(50,21001,30080,30710,30140,30040,30630,30240,30610,30780,30130,30070,30670,30870,30220,30860,30530,30770,30150)

VE.ridge.w <- list()
VE.ridge.all <- list()
VE.ridge1 <- list()
VE.ridge2 <- list()
stem <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/"
path <- c("geno/test1/","geno_1kg/")
for( k in 1:length(path) ){
    VE.ridge.w[[k]] <- matrix(ncol=3,nrow=length(phenos))
    VE.ridge.all[[k]] <- matrix(ncol=3,nrow=length(phenos))
    VE.ridge1[[k]] <- matrix(ncol=3,nrow=length(phenos))
    VE.ridge2[[k]] <- matrix(ncol=3,nrow=length(phenos))
    rownames(VE.ridge.w[[k]]) <- phenos
    rownames(VE.ridge.all[[k]]) <- phenos
    rownames(VE.ridge1[[k]]) <- phenos
    rownames(VE.ridge2[[k]]) <- phenos
    for( i in 1:length(phenos) ){
        infile <- paste0(stem,path[k],phenos[i],"/AFR_weighted_combined_var_explained.txt")
        if( file.exists(infile) ){
            tmp <- fread(infile,data.table=FALSE)
            print(phenos[i])
            print(tmp)
            VE.ridge.all[[k]][i,] <- as.numeric(tmp[1,3:5])
            VE.ridge2[[k]][i,] <- as.numeric(tmp[2,3:5])
            VE.ridge1[[k]][i,] <- as.numeric(tmp[3,3:5])
            VE.ridge.w[[k]][i,] <- as.numeric(tmp[4,3:5])
        }
    }
}
for( k in 1:length(path) ){
    print( c( mean(VE.ridge.all[[k]][,1]), mean(VE.ridge.w[[k]][,1]),
             mean(VE.ridge1[[k]][,1]), mean(VE.ridge2[[k]][,1]) ) )
}
tmp=cbind( VE.csx[,1:2], VE.prsice[,2],
          VE.ridge.w[[1]][,1], VE.ridge.all[[1]][,1],
          VE.ridge.w[[2]][,1], VE.ridge.all[[2]][,1] )
colnames(tmp)=c('trait','csx','prsice','ridge1','ridge11','ridge2','ridge22')


####################################
tau.bbj <- matrix( ncol=8, nrow=length(phenos.bbj) )
alpha.bbj <- matrix( ncol=5, nrow=length(phenos.bbj) )
lambda.bbj <- matrix( ncol=11, nrow=length(phenos.bbj) )
path.bbj <- c("/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ/test/")
for( i in 1:length(phenos.bbj) ){
    infile <- paste0(path.bbj,phenos.bbj[i],"/EAS_tau_weights.dat")
    res <- read.table(infile)
    tau.bbj[i,] <- res[,1]
    colnames(tau.bbj) <- rownames(res)

    infile <- paste0(path.bbj,phenos.bbj[i],"/EAS_alpha_weights.dat")
    res <- read.table(infile)
    alpha.bbj[i,] <- res[,1]
    colnames(alpha.bbj) <- rownames(res)

    infile <- paste0(path.bbj,phenos.bbj[i],"/EAS_lambda_weights.dat")
    res <- read.table(infile)
    lambda.bbj[i,] <- res[,1]
    colnames(lambda.bbj) <- rownames(res)
}
rownames(tau.bbj) <- phenos.bbj
rownames(alpha.bbj) <- phenos.bbj
rownames(lambda.bbj) <- phenos.bbj

path <- c("/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/geno/test1/",
          "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/imputed/test11/",
          "/sc/arion/work/hoggac01/ukb_pheno_results/",
          "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/geno/test1/",
          "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/imputed/test11/",
          "/sc/arion/work/hoggac01/ukb_pheno_results/")
pop <- c("/AFR","/afr","/test5/afr","/SAS","/SAS","/test5/SAS")
tau <- list()
alpha <- list()
lambda <- list()
n.tau <- c(10,9,9,10,10,10)
for( k in 1:6 ){
    tau[[k]] <- matrix( ncol=n.tau[k], nrow=length(phenos) )
    alpha[[k]] <- matrix( ncol=5, nrow=length(phenos) )
    lambda[[k]] <- matrix( ncol=7, nrow=length(phenos) )
    for( i in 1:length(phenos) ){
        infile <- paste0(path[k],phenos[i],pop[k],"_tau_weights.dat")
        res <- read.table(infile)
        tau[[k]][i,] <- res[,1]
        colnames(tau[[k]]) <- rownames(res)

        infile <- paste0(path[k],phenos[i],pop[k],"_alpha_weights.dat")
        res <- read.table(infile)
        alpha[[k]][i,] <- res[,1]
        colnames(alpha[[k]]) <- rownames(res)

        infile <- paste0(path[k],phenos[i],pop[k],"_lambda_weights.dat")
        res <- read.table(infile)
        lambda[[k]][i,] <- res[,1]
        colnames(lambda[[k]]) <- rownames(res)
    }
    rownames(tau[[k]]) <- phenos
    rownames(alpha[[k]]) <- phenos
    rownames(lambda[[k]]) <- phenos
}
