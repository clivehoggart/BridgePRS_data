library(data.table)
phenos <- c(50,21001,30080,30710,30140,30040,30630,30240,30610,30780,30130,30070,30670,30870,30220,30860,30530,30770,30150)
stem <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/analysis/prscsx/"
pop <- "SAS"
stem2 <- paste0("/result/adjusted_effect/",pop,"-")
stem.phi <- paste0("/result/validate/",pop,"-")
switch.id <- matrix(ncol=2,nrow=0)
for( i in 2:length(phenos) ){
    phi.file <- paste0( stem, phenos[i], stem.phi, phenos[i],".performance")
    phi <- fread(phi.file)
    phi <- formatC(phi$Phi, format="f", digits=-log10(phi$Phi))
    infile <- paste0( stem, phenos[i], stem2, phenos[i],"-",phi,".sumstat.gz")
    score <- fread(infile)
    new.id <- paste( score$CHR, score$BP, sep=":" )
    score <- data.frame( score, new.id )
    outfile <- paste0( stem, phenos[i], stem2, phenos[i],"-best.sumstat")
    write.table( score, file=outfile, row.names=FALSE, col.names=TRUE, quote=FALSE )
    switch.id <- rbind( switch.id, cbind( score$ID, new.id ) )
}
u.posn <- unique(switch.id[,2])
switch.id.u <- switch.id[match(u.posn,switch.id[,2]),]
write.table( switch.id.u, paste0("~/biome/switch_id_",pop,"_csx.txt"),
            row.names=FALSE, col.names=FALSE, quote=FALSE )
