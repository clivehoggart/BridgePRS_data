library(data.table)
x1 <- fread('/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/50/EAS-test.dat',data.table=FALSE)
x2 <- fread('/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/50/EAS-valid.dat',data.table=FALSE)

x1 <- x1[,-match("Phenotype",colnames(x1))]
x2 <- x2[,-match("Phenotype",colnames(x2))]

z <- fread('~/ukb_phenos.csv')
x <- rbind(x1,x2)
ids <- intersect(x$IID,z$IID)
x <- x[match(ids,x$IID),]
z <- z[match(ids,z$IID),]

x <- as.data.frame(x)
z <- as.data.frame(z)
data <- list()
for( i in 1:10 ){
    data[[i]] <- data.frame( x, z[,c(3,4,(i+4))] )

}
phenos <- colnames(z)[5:14]
tmp <- strsplit(phenos,"X")
phenos <- sapply( tmp, getElement, 2 )

path <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/"

ptr.phenos.fill <- match( c(30610,30710,30780,30860,30870), phenos )

for( i in ptr.phenos.fill ){
    print(phenos[i])
    fname0 <- paste0( path, phenos[i], "/EAS-all.dat" )
    fname1 <- paste0( path, phenos[i], "/EAS-test.dat" )
    fname2 <- paste0( path, phenos[i], "/EAS-valid.dat" )
    colnames(data[[i]])[49] <- "Phenotype"
    write.table( data[[i]], fname0, quote=FALSE, row.names=FALSE )
    write.table( data[[i]][1:1035,], fname1, quote=FALSE, row.names=FALSE )
    write.table( data[[i]][-(1:1035),], fname2, quote=FALSE, row.names=FALSE )
}
