index <- matrix(ncol=4,nrow=0)
for( phenos in 1:30 ){
    for( pops in 0:2 ){
        for( causal in 0:1 ){
            for( chr in 1:22 ){
                index <- rbind( index, c( causal, pops, phenos, chr ) )
            }
        }
    }
}
write.table( index, 'clump_index.dat', row.names=FALSE, col.names=FALSE )

