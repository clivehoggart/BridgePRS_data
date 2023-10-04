index <- matrix(ncol=3,nrow=0)
for( k in 0:12 ){
    for( l in 1:22 ){
        index <- rbind( index, c( k, l ) )
    }
}
write.table( index, 'cs_index.dat', row.names=FALSE, col.names=FALSE )

