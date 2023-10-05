index <- matrix(ncol=3,nrow=0)
for( j in 0:2 ){#pop
    for( k in 0:18 ){
        for( l in 1:22 ){
            index <- rbind( index, c( j, k, l ) )
        }
    }
}
write.table( index, 'cs_index.dat', row.names=FALSE, col.names=FALSE )
