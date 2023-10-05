library(data.table)
phenos <- c(50,    21001, 30610,30220,30710,30150, 30780,30040,30130,30140, 30080,30870, 30860)
stem <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype"
for( i in 1:length(phenos) ){
    file.stem <- paste0( stem, "/", phenos[i], "/EAS-", phenos[i] )
    infile <- paste0( file.stem, ".base" )
    if( file.exists(infile) ){
        x1 <- fread(infile)
        x2 <- fread(paste0( file.stem, ".valid" ))
        x3 <- fread(paste0( file.stem, ".target" ))
        x <- rbind( x1, x2, x3 )
        ptr.test <- 1:ceiling(nrow(x)/2)
        ptr.valid <-  setdiff( 1:nrow(x), ptr.test )
        file.stem <- paste0( stem, "/", phenos[i], "/EAS-" )
        write.table( x, paste0( file.stem, "all.dat" ),
                    quote=FALSE, row.names=FALSE )
        write.table( x[ptr.test,], paste0( file.stem, "test.dat" ),
                    quote=FALSE, row.names=FALSE )
        write.table( x[ptr.valid,], paste0( file.stem, "valid.dat" ),
                    quote=FALSE, row.names=FALSE)
    }
    if( !file.exists(infile) ){
        print(infile)
    }
}
