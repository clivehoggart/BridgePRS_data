source('~/bin/my_forestplot.R')
source('~/bin/functions.R')
library(data.table)
library(RColorBrewer)

blue <- brewer.pal(5, 'Blues')
red <- brewer.pal(5, 'Reds')
green <- brewer.pal(5, 'Greens')
purple <- brewer.pal(5, 'Purples')
grey <- brewer.pal(5, 'Greys')

tab.ukb <- matrix( ncol=6, nrow=4 )

eff.ukb <- list()
pop <- c('AFR','SAS')
for( i in 1:2 ){
    csx.imputed <- read.table(paste0('~/csx_results/',pop[i],'_ukb_imputed.dat'))
    ridge.imputed <- read.table(paste0('~/ridgeprs/results/',pop[i],'_ukb_imputed.dat'))
    ptr <- match( ridge.imputed$V1, csx.imputed$V1 )
    csx.imputed <- csx.imputed[ptr,]
    print( t.test(ridge.imputed$V2-csx.imputed$V2)$p.value )

    if( pop[i]=='AFR' ){
        effect <- cbind( ridge.imputed[,2], csx.imputed[,2] )
        s <- order(apply(effect,1,max),decreasing=T)
    }
    traits <- fread('~/ridgeprs/ukb/ukb_traits.csv')
    phen.nmes <- traits$Field[match(ridge.imputed$V1, traits$FieldID)]
    traits <- c('BMI','Platelets','CRP','Neutro count','MCV','apoA1','Retic count',
                'ALP','LDL','Mono count','RDW','Urea','TG','Baso %','Total Protein',
                'Urine sodium','IGDF-1','Eos count','Height')

    pdf(paste0('~/ridgeprs/ridgePRS/text/forest_wcpg_ukb_',pop[i],'.pdf'),width=15,height=18)
    ptr <- c(1:14,15,17)
    effect <- cbind( ridge.imputed[,2], csx.imputed[,2] )[s[ptr],]
    l.ci <- cbind( ridge.imputed[,3], csx.imputed[,3] )[s[ptr],]
    u.ci <- cbind( ridge.imputed[,4], csx.imputed[,4] )[s[ptr],]
    lab <- traits[s[ptr]]
    r2 <- signif(apply(effect,2,mean),2)
    legend <- c(paste0('BridgePRS: mean R2=',r2[1]),
                paste('PRS-CSx: mean R2=',r2[2]) )

    if( pop[i]=='AFR' ){
        xticks <- c(-0.025,seq(from=0,to=.175,by=.025))
    }
    if( pop[i]=='SAS' ){
        xticks <- c(-0.025,seq(from=0,to=.25,by=.05))
    }
    xtlab <- c( FALSE, rep(TRUE,length(xticks)-1) )
#attr(xticks, "labels") <- xtlab

    my.forestplot2( lab=lab, effect=effect, l.ci=l.ci, u.ci=u.ci, new_page=FALSE, cols=c(red[3],blue[3]), cex=2.5, xlab="R2", line.margin=0.25, xticks=xticks, clip=c(-0.025,max(xticks)), legend=legend )
    txt <- ifelse( pop[i]=="AFR", "African", "South Asian" )
    grid.text( txt, 0.15, .98, gp=gpar(cex=4,fontface="bold"), hjust='center' )
    dev.off()
}
