library(data.table)

phenos <- c(21001,30080,30710,30140,30040,30630,30240,30610,30780,30130,30070,30670,30870,30220,30860,30530,30770,30150,50)

VE.ridge.w <- list()
VE.ridge.all <- list()
VE.ridge1 <- list()
VE.ridge2 <- list()
pop <- c("afr","SAS")
path <- c(
    "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/geno/test1/",
    "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/imputed/test11/",
    "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/geno/test1/")
for( j in 2:2 ){
    VE.ridge.w[[j]] <- list()
    VE.ridge.all[[j]] <- list()
    VE.ridge1[[j]] <- list()
    VE.ridge2[[j]] <- list()
    for( k in 1:1 ){
        VE.ridge.w[[j]][[k]] <- matrix(ncol=3,nrow=length(phenos))
        VE.ridge.all[[j]][[k]] <- matrix(ncol=3,nrow=length(phenos))
        VE.ridge1[[j]][[k]] <- matrix(ncol=3,nrow=length(phenos))
        VE.ridge2[[j]][[k]] <- matrix(ncol=3,nrow=length(phenos))
        rownames(VE.ridge.w[[j]][[k]]) <- phenos
        rownames(VE.ridge.all[[j]][[k]]) <- phenos
        rownames(VE.ridge1[[j]][[k]]) <- phenos
        rownames(VE.ridge2[[j]][[k]]) <- phenos
        for( i in 1:length(phenos) ){
            infile <- paste0(path[j],phenos[i],"/",pop[k],"_weighted_combined_var_explained.txt")
            if( file.exists(infile) ){
                tmp <- fread(infile,data.table=FALSE)
                print(phenos[i])
                print(tmp[1:4,])
                VE.ridge.all[[j]][[k]][i,] <- as.numeric(tmp[1,3:5])
                VE.ridge2[[j]][[k]][i,] <- as.numeric(tmp[2,3:5])
                VE.ridge1[[j]][[k]][i,] <- as.numeric(tmp[3,3:5])
                VE.ridge.w[[j]][[k]][i,] <- as.numeric(tmp[4,3:5])
            }
        }
    }
}
