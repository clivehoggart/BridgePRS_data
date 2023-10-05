library(data.table)
dir <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen"
pop <- c('afr','eas','eur')
nn <- c(40e3,40e3,100e3)
h2 <- 0.75
for( j in 1:30 ){
    pheno <- list()
    for( i in 1:3 ){
        for( chr in 1:22 ){
            tmp <- fread(paste0(dir,'/scores/chr',chr,'_',pop[i],'_scores',j,'.sscore'),
                         data.table=FALSE)
            if( chr==1 ){
                pheno[[i]] <- tmp[,c(1,2,6)]
            }else{
                pheno[[i]][,3] <- pheno[[i]][,3] + tmp[,6]
            }
        }
        pheno[[i]][,3] <-  100*pheno[[i]][,3]
        sigma2.g <- var( pheno[[i]][,3] )
        sigma2.e <- sigma2.g*(1-h2)/h2
        e <- rnorm( n=nn[i], sd=sqrt(sigma2.e) )
        pheno[[i]][,3]  <- pheno[[i]][,3] + e
        print(c(j,pop[i]))
        print( c(mean(pheno[[i]][,3]), sigma2.g / (sigma2.g+sigma2.e) ) )
        colnames(pheno[[i]])[3] <- paste0('SCORE',j,'_AVG')
        write.table( pheno[[i]][1:1e4,],
                    paste0(dir,'/scores75/SCORE',j,'_AVG','_',pop[i],'_valid.dat'),
                    quote=FALSE, row.names=FALSE )
        write.table( pheno[[i]][10001:2e4,],
                    paste0(dir,'/scores75/SCORE',j,'_AVG','_',pop[i],'_test.dat'),
                    quote=FALSE, row.names=FALSE )
        write.table( pheno[[i]][-(1:2e4),],
                    paste0(dir,'/scores75/SCORE',j,'_AVG','_',pop[i],'_train.dat'),
                    quote=FALSE, row.names=FALSE )
    }
}

