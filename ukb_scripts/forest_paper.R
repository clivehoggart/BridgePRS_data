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

cex2 <- 5
eff.ukb <- list()
pop <- c('AFR','SAS','EAS')
n <- list()
n[['AFR']] <- c( 1212, 1163, 819, 1159, 1164, 756, 1131, 822, 821, 1158,
                1160, 821, 821, 1154, 760, 1182, 817, 1156, 1214 )
n[['SAS']] <- c( 1662, 1633, 1144, 1627, 1634, 1044, 1590, 1152, 1150,
                1625, 1630, 1149, 1149, 1622, 1046, 1623, 1144, 1624, 1665 )
n[['EAS']] <- c( 1233, 1203, 1034, 1201, 1203, NA, NA, 1034, 1034,
                 1202, NA, NA, 1034, 1199, 1034, NA, NA, 1197, 1235 )

for( i in 1:3 ){
    if( i<3 ){
        cs.imputed <- read.table(paste0('~/ukb/cs_res/',pop[i],'.dat'))
        csx.imputed <- read.table(paste0('~/ukb/csx_results/',pop[i],'_ukb_imputed.dat'))
        prsice.imputed <- read.table(paste0('~/ukb/prsice_res/',pop[i],'_imputed.dat'))
        ridge.imputed <- read.table(paste0('~/ukb/ridge_results/',pop[i],'_ukb_imputed.dat'))
    }else{
        cs.imputed <- fread('~/bbj/cs_var_explained.dat')
        csx.imputed <- fread('~/bbj/csx_var_explained.tsv')
        prsice.imputed <- fread('~/ukb/prsice_res/EAS_imputed.dat')
        ridge.imputed <- fread('~/bbj/ridge_var_explained.dat')
    }
    ptr <- match( ridge.imputed$V1, csx.imputed$V1 )
    csx.imputed <- csx.imputed[ptr,]
    ptr <- match( ridge.imputed$V1, cs.imputed$V1 )
    cs.imputed <- cs.imputed[ptr,]
    ptr <- match( ridge.imputed$V1, prsice.imputed$V1 )
    prsice.imputed <- prsice.imputed[ptr,]

    if( pop[i]=='AFR' ){
        traits <- c('BMI','Platelets','CRP','Neutro count','MCV','apoA1','Retic count',
                    'ALP','LDL','Mono count','RDW','Urea','TG','Baso %','Total Protein',
                    'Urine sodium','IGDF-1','Eos count','Height')
        effect <- cbind( ridge.imputed[,2], csx.imputed[,2],
                        cs.imputed[,2], prsice.imputed[,2] )
        s <- order(apply(effect,1,max),decreasing=TRUE)
        ptr1 <- c(1:14,15,17)
        print( traits[s[-ptr1]] )
        ptr1 <- s[ptr1]
        ptr1 <- s
        trait.codes <- ridge.imputed[ptr1,1]
        traits <- traits[ptr1]
    }
    nn <- n[[pop[i]]][ptr1]
    if( pop[i]=='EAS' ){
        nn <- n[[pop[i]]][ptr1]
        ptr <- match( trait.codes, ridge.imputed$V1 )
        ptr1 <- ptr[!is.na(ptr)]
        ptr2 <- match( ridge.imputed$V1[ptr1], trait.codes )
        traits <- traits[ptr2]
        nn <- nn[ptr2]
    }

    height <- ifelse( pop[i]=='EAS', 20, 30 )
    pdf(paste0('~/ridgeprs/ridgePRS/text/forest_ukb_',pop[i],'.pdf'),
        width=15, height=height )
    margin(t = 0, r = 0, b = 0, l = 0, unit = "pt")
    effect <- cbind( ridge.imputed$V2, csx.imputed$V2,
                        cs.imputed$V2, prsice.imputed$V2 )[ptr1,]
    l.ci <- cbind( ridge.imputed$V3, csx.imputed$V3,
                        cs.imputed$V3, prsice.imputed$V3 )[ptr1,]
    u.ci <- cbind( ridge.imputed$V4, csx.imputed$V4,
                        cs.imputed$V4, prsice.imputed$V4 )[ptr1,]
    lab <- traits
#    r2 <- signif(apply(effect,2,mean),2)
#    legend <- c(paste0('BridgePRS: mean R2=',r2[1]),
#                paste('PRS-CSx: mean R2=',r2[2]) )

    if( pop[i]=='AFR' ){
        xticks <- c(-0.025,seq(from=0,to=.175,by=.025))
        legend <- c('BridgePRS','PRS-CSx','PRS-CS-mult','PRSice-meta' )
    }
    if( pop[i]=='SAS' ){
        xticks <- c(-0.025,seq(from=0,to=.25,by=.05))
        legend <- NULL
    }
    if( pop[i]=='EAS' ){
        xticks <- c(-0.025,seq(from=0,to=.3,by=.1))
        legend <- NULL
    }
    xtlab <- c( FALSE, rep(TRUE,length(xticks)-1) )
#attr(xticks, "labels") <- xtlab

    my.forestplot4( lab=lab, baseline=nn, effect=effect, l.ci=l.ci, u.ci=u.ci,
                   new_page=FALSE, cols=c(red[3],purple[3],blue[3],green[3]),
                   cex=3.5, xlab=expression(R^2), line.margin=0.25, mar=4*c(0,4,0,6),
                   xticks=xticks, clip=c(-0.025,max(xticks)), legend=legend )
    if( pop[i]=='AFR' ){
#        grid.text("a", x=0,y=.97, gp=gpar(cex=4,fontface="bold"), just='left' )
        grid.text("African target", y=0.97, gp=gpar(cex=cex2,fontface="bold"), just='center' )
    }
    if( pop[i]=='SAS' ){
#        grid.text("b", x=0,y=.97, gp=gpar(cex=4,fontface="bold"), just='left' )
        grid.text("South Asian target", y=.97, gp=gpar(cex=cex2,fontface="bold"), just='center' )
    }
    if( pop[i]=='EAS' ){
#        grid.text("c", x=0,y=.97, gp=gpar(cex=4,fontface="bold"), just='left' )
        grid.text("East Asian target", y=.97, gp=gpar(cex=cex2,fontface="bold"), just='center' )
    }
    dev.off()
}
