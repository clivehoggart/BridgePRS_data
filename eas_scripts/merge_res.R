library(data.table)

phenos <- c(50,    21001, 30610,30220,30710,30150, 30780,30040,30130,30140, 30080,30870, 30860)

VE.prsice <- fread("~/bbj/prsice_var_explained.tsv",data.table=FALSE)
VE.csx <- fread("~/bbj/csx_var_explained.tsv",data.table=FALSE)

VE.ridge.w <- list()
VE.ridge.all <- list()
VE.ridge1 <- list()
VE.ridge2 <- list()
path <- c("test/","1000G_ld_shrink/")
for( k in 1:2 ){
    VE.ridge.w[[k]] <- matrix(ncol=3,nrow=length(phenos))
    VE.ridge.all[[k]] <- matrix(ncol=3,nrow=length(phenos))
    VE.ridge1[[k]] <- matrix(ncol=3,nrow=length(phenos))
    VE.ridge2[[k]] <- matrix(ncol=3,nrow=length(phenos))
    rownames(VE.ridge.w[[k]]) <- phenos
    rownames(VE.ridge.all[[k]]) <- phenos
    rownames(VE.ridge1[[k]]) <- phenos
    rownames(VE.ridge2[[k]]) <- phenos
    for( i in 1:length(phenos) ){
        infile <- paste0("/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ/",path[k],phenos[i],"/EAS_weighted_combined_var_explained.txt")
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
