source('~/bin/my_forestplot.R')

phenos <- c(50,21001,30080,30710,30140,30040,30630,30240,30610,30780,30130,30070,30670,30870,30220,30860,30530,30770,30150)

ukb <- matrix(ncol=3,nrow=length(phenos))
kg <- matrix(ncol=3,nrow=length(phenos))

for( i in 1:length(phenos) ){
    infile0 <- paste0("/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/geno/test1/",phenos[i],"/AFR_weighted_combined_var_explained.txt")
    infile1 <- paste0("/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/geno_1kg/",phenos[i],"/AFR_weighted_combined_var_explained.txt")
    tmp0 <- read.csv(infile0)
    tmp1 <- read.csv(infile1)
    kg[i,] <- as.numeric( tmp1[4,3:5])
    ukb[i,] <- as.numeric( tmp0[4,3:5])
}
s <- order(ukb[,1],decreasing=TRUE)

pdf(paste0('~/ukb/forestplot_ukb_1kg.pdf'),
    width=15,height=20)#,paper='special')
effect <- cbind( ukb[,1], kg[,1] )[s,]
l.ci <- cbind( ukb[,2], kg[,2] )[s,]
u.ci <- cbind( ukb[,3], kg[,3] )[s,]
lab <- phenos[s]

xticks <- c(-0.025,seq(from=0,to=.3,by=.05))
xtlab <- c( FALSE, rep(TRUE,length(xticks)-1) )

my.forestplot2( lab=lab, effect=effect, l.ci=l.ci, u.ci=u.ci, new_page=FALSE,
               cols=c('blue','salmon'),
               clip=c(-0.025,max(xticks)),
               cex=2.5, xlab="R2", line.margin=0.2, xticks=xticks )

dev.off()
