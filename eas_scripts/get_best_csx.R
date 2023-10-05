# Identifies csx phi model which best fits test data and write out to "-best.sumstat"

library(data.table)
phenos <- c(50,    21001, 30610,30220,30710,30150, 30780,30040,30130,30140, 30080,30870, 30860)
stem <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/analysis/prscsx/bbj/"
pop <- "EAS"
stem2 <- paste0("/result/adjusted_effect/",pop,"-")
stem.phi <- paste0("/result/validate/",pop,"-")
switch.id <- matrix(ncol=2,nrow=0)
n.model.var <- vector()
for( i in 1:length(phenos) ){
    phi.file <- paste0( stem, phenos[i], stem.phi, phenos[i],".performance")
    phi <- fread(phi.file)
    phi <- formatC(phi$Phi, format="f", digits=-log10(phi$Phi))
    infile <- paste0( stem, phenos[i], stem2, phenos[i],"-",phi,".sumstat.gz")
    score <- fread(infile)
    n.model.var[i] <- nrow(score)
    outfile <- paste0( stem, phenos[i], stem2, phenos[i],"-best.sumstat")
    write.table( score, file=outfile, row.names=FALSE, col.names=TRUE, quote=FALSE )
}

n.model.var.sas <- data.frame( n.model.var.sas, n.model.var )
n.model.var.afr <- data.frame( n.model.var.afr, n.model.var )
colnames(n.model.var.sas)[4] <- "csx"
colnames(n.model.var.afr)[4] <- "csx"
