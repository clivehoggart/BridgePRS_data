library(data.table)

afr.csx <- fread('~/ukb/csx_results/AFR_ukb_imputed.dat')
afr.ridge <- fread('~/ukb/ridge_results/AFR_ukb_imputed.dat')
afr.prsice <- fread('~/ukb/prsice_res/AFR_imputed.dat')
afr.cs <- fread('~/ukb/cs_res/AFR.dat')
s <- order(afr.ridge$V2,decreasing=TRUE)
afr.ridge <- afr.ridge[s,]
afr.csx <- afr.csx[match(afr.ridge$V1,afr.csx$V1),]
afr.cs <- afr.cs[match(afr.ridge$V1,afr.cs$V1),]
afr.prsice <- afr.prsice[match(afr.ridge$V1,afr.prsice$V1),]
afr <- cbind( afr.ridge$V2, afr.csx$V2, afr.cs$V2, afr.prsice$V2 )
colnames(afr) <- c('ridge','csx','cs.mult','prsice.meta')
rownames(afr) <- afr.ridge$V1
#write.table( afr, '~/afr_ukb.dat',sep='\t' )
afr.se.avg <- vector()
afr.ridge.se <- (afr.ridge$V4-afr.ridge$V3)/(2*1.96)
afr.se.avg[1] <- sqrt(sum(afr.ridge.se^2))/19
afr.csx.se <- (afr.csx$V4-afr.csx$V3)/(2*1.96)
afr.se.avg[2] <- sqrt(sum(afr.csx.se^2))/19
afr.cs.se <- (afr.cs$V4-afr.cs$V3)/(2*1.96)
afr.se.avg[3] <- sqrt(sum(afr.cs.se^2))/19
afr.prsice.se <- (afr.prsice$V4-afr.prsice$V3)/(2*1.96)
afr.se.avg[4] <- sqrt(sum(afr.prsice.se^2))/19
m <- apply(afr,2,mean)
afr.ci <- cbind( m, m-1.96*afr.se.avg, m+1.96*afr.se.avg )

afr.t <- matrix( ncol=3, nrow=3 )
rownames(afr.t) <- c('ridge','csx','cs.mult')
colnames(afr.t) <- c('csx','cs.mult','prsice.meta')
for( i in 1:3 ){
    for( j in (i+1):4 ){
        m.diff <- m[i]-m[j]
        se.diff <- sqrt(afr.se.avg[i]^2 + afr.se.avg[j]^2)
        afr.t[i,(j-1)] <- as.numeric(abs(m.diff) / se.diff)
    }
}

sas.csx <- fread('~/ukb/csx_results/SAS_ukb_imputed.dat')
sas.ridge <- fread('~/ukb/ridge_results/SAS_ukb_imputed.dat')
sas.prsice <- fread('~/ukb/prsice_res/SAS_imputed.dat')
sas.cs <- fread('~/ukb/cs_res/SAS.dat')
s <- order(sas.ridge$V2,decreasing=TRUE)
sas.ridge <- sas.ridge[s,]
sas.csx <- sas.csx[match(sas.ridge$V1,sas.csx$V1),]
sas.cs <- sas.cs[match(sas.ridge$V1,sas.cs$V1),]
sas.prsice <- sas.prsice[match(sas.ridge$V1,sas.prsice$V1),]
sas <- cbind( sas.ridge$V2, sas.csx$V2, sas.cs$V2, sas.prsice$V2 )
colnames(sas) <- c('ridge','csx','cs.mult','prsice.meta')
rownames(sas) <- sas.ridge$V1
#write.table( sas, '~/sas_ukb.dat',sep='\t' )
sas.se.avg <- vector()
sas.ridge.se <- (sas.ridge$V4-sas.ridge$V3)/(2*1.96)
sas.se.avg[1] <- sqrt(sum(sas.ridge.se^2))/19
sas.csx.se <- (sas.csx$V4-sas.csx$V3)/(2*1.96)
sas.se.avg[2] <- sqrt(sum(sas.csx.se^2))/19
sas.cs.se <- (sas.cs$V4-sas.cs$V3)/(2*1.96)
sas.se.avg[3] <- sqrt(sum(sas.cs.se^2))/19
sas.prsice.se <- (sas.prsice$V4-sas.prsice$V3)/(2*1.96)
sas.se.avg[4] <- sqrt(sum(sas.prsice.se^2))/19
m <- apply(sas,2,mean)
sas.ci <- cbind( m, m-1.96*sas.se.avg, m+1.96*sas.se.avg )

sas.t <- matrix( ncol=3, nrow=3 )
rownames(sas.t) <- c('ridge','csx','cs.mult')
colnames(sas.t) <- c('csx','cs.mult','prsice.meta')
for( i in 1:3 ){
    for( j in (i+1):4 ){
        m.diff <- m[i]-m[j]
        se.diff <- sqrt(sas.se.avg[i]^2 + sas.se.avg[j]^2)
        sas.t[i,(j-1)] <- as.numeric(abs(m.diff) / se.diff)
    }
}

eas.csx <- fread('~/bbj/csx_var_explained.tsv')
eas.cs <- fread('~/bbj/cs_var_explained.dat')
eas.ridge <- fread('~/bbj/ridge_var_explained.dat')
eas.prsice <- fread('~/ukb/prsice_res/EAS_imputed.dat')
prsice.phenos <- c( 50,     21001, 30610, 30220, 30710, 30150,  30780, 30040, 30130, 30140,  30080, 30870, 30860)
s <- order(eas.ridge$V2,decreasing=TRUE)
eas.ridge <- eas.ridge[s,]
eas.csx <- eas.csx[match(eas.ridge$V1, eas.csx$V1),]
eas.cs <- eas.cs[match(eas.ridge$V1, eas.cs$V1),]
eas.prsice <- eas.prsice[match(eas.ridge$V1, eas.prsice$V1),]
eas <- cbind( eas.ridge$V2, eas.csx$V2, eas.cs$V2, eas.prsice$V2 )
colnames(eas) <- c('ridge','csx','cs.mult','prsice.meta')
rownames(eas) <- eas.ridge$V1
#write.table( eas, '~/eas_ukb.dat',sep='\t' )
eas.se.avg <- vector()
eas.ridge.se <- (eas.ridge$V4-eas.ridge$V3)/(2*1.96)
eas.se.avg[1] <- sqrt(sum(eas.ridge.se^2))/19
eas.csx.se <- (eas.csx$V4-eas.csx$V3)/(2*1.96)
eas.se.avg[2] <- sqrt(sum(eas.csx.se^2))/19
eas.cs.se <- (eas.cs$V4-eas.cs$V3)/(2*1.96)
eas.se.avg[3] <- sqrt(sum(eas.cs.se^2))/19
eas.prsice.se <- (eas.prsice$V4-eas.prsice$V3)/(2*1.96)
eas.se.avg[4] <- sqrt(sum(eas.prsice.se^2))/19
m <- apply(eas,2,mean)
eas.ci <- cbind( m, m-1.96*eas.se.avg, m+1.96*eas.se.avg )

eas.t <- matrix( ncol=3, nrow=3 )
rownames(eas.t) <- c('ridge','csx','cs.mult')
colnames(eas.t) <- c('csx','cs.mult','prsice.meta')
for( i in 1:3 ){
    for( j in (i+1):4 ){
        m.diff <- m[i]-m[j]
        se.diff <- sqrt(eas.se.avg[i]^2 + eas.se.avg[j]^2)
        eas.t[i,(j-1)] <- as.numeric(abs(m.diff) / se.diff)
    }
}

library(RColorBrewer)

blue <- brewer.pal(5, 'Blues')
red <- brewer.pal(5, 'Reds')
green <- brewer.pal(5, 'Greens')
purple <- brewer.pal(5, 'Purples')
grey <- brewer.pal(5, 'Greys')

cex1 <- 1.7
cex2 <- 2.5

#pdf('~/ridgeprs/paper/summary_afr_ukb.pdf',width=8,height=8)
pdf('~/ridgeprs/ridgePRS/text/summary_afr_ukb.pdf',width=8,height=8)
par(mar=c(4,5,3,1))
b <- barplot( afr.ci[4:1,1], ylim=c(0,max(afr.ci)+0.02), cex.lab=cex1, cex.axis=cex1,
             col=c(green[3],blue[3],purple[3],red[3]), xaxt='n', ylab="Average R2" )
axis( side=1, at=b, labels=c('PRSice-meta','CS-mult','PRS-CSx','BridgePRS'),
     cex.axis=cex1 )
arrows( x0=b, x1=b, y0=afr.ci[4:1,2], y1=afr.ci[4:1,3], code=3, angle=90 )
#mtext( 'a', side=3, adj=0, font=2, line=1, cex=cex2 )
mtext( 'African target', side=3, adj=0.5, font=2, line=1, cex=cex2 )

p <- signif(pnorm(afr.t,lower.tail=FALSE)*2,2)

arrows( x0=b[2]+0.05, x1=b[3]-0.05,
       y0=max(afr.ci[2:3,3])+0.002, y1=max(afr.ci[2:3,3])+0.002,
       angle=90, code=3, length=0.05 )
text( x=(b[2]+b[3])/2, y=max(afr.ci[2:3,3])+0.005, paste0('p=',p[2,2] ), cex=cex1)

arrows( x0=b[3]+0.05, x1=b[4]-0.05,
       y0=max(afr.ci[1:2,3])+0.002, y1=max(afr.ci[1:2,3])+0.002,
       angle=90, code=3, length=0.05 )
text( x=(b[4]+b[3])/2, y=max(afr.ci[1:2,3])+0.005, paste0('p=',p[1,1]), cex=cex1 )

arrows( x0=b[2]+0.05, x1=b[4]-0.05,
       y0=max(afr.ci[1:3,3])+0.012, y1=max(afr.ci[1:3,3])+0.012,
       angle=90, code=3, length=0.05 )
text( x=b[3], y=max(afr.ci[1:2,3])+0.015, paste0('p=',p[1,2]), cex=cex1 )

dev.off()

#pdf('~/ridgeprs/paper/summary_sas_ukb.pdf',width=8,height=8)
pdf('~/ridgeprs/ridgePRS/text/summary_sas_ukb.pdf',width=8,height=8)
par(mar=c(4,5,3,1))
b <- barplot(sas.ci[4:1,1],ylim=c(0,max(sas.ci)+0.02), cex.lab=cex1, cex.axis=cex1,
             col=c(green[3],blue[3],purple[3],red[3]), xaxt='n', ylab="Average R2" )
axis( side=1, at=b, labels=c('PRSice-meta','CS-mult','PRS-CSx','BridgePRS'),
     cex.axis=cex1 )
arrows( x0=b, x1=b, y0=sas.ci[4:1,2], y1=sas.ci[4:1,3], code=3, angle=90 )
#mtext( 'b', side=3, adj=0, font=2, line=1, cex=cex2 )
mtext( 'South Asian target', side=3, adj=0.5, font=2, line=1, cex=cex2 )

p <- signif(pnorm(sas.t,lower.tail=FALSE)*2,2)

arrows( x0=b[2]+0.05, x1=b[3]-0.05,
       y0=max(sas.ci[2:3,3])+0.002, y1=max(sas.ci[2:3,3])+0.002,
       angle=90, code=3, length=0.05 )
text( x=(b[2]+b[3])/2, y=max(sas.ci[2:3,3])+0.005, paste0('p=',p[2,2] ), cex=cex1)

arrows( x0=b[3]+0.05, x1=b[4]-0.05,
       y0=max(sas.ci[1:2,3])+0.002, y1=max(sas.ci[1:2,3])+0.002,
       angle=90, code=3, length=0.05 )
text( x=(b[4]+b[3])/2, y=max(sas.ci[1:2,3])+0.005, paste0('p=',p[1,1]), cex=cex1 )

arrows( x0=b[2]+0.05, x1=b[4]-0.05,
       y0=max(sas.ci[1:3,3])+0.012, y1=max(sas.ci[1:3,3])+0.012,
       angle=90, code=3, length=0.05 )
text( x=b[3], y=max(sas.ci[1:2,3])+0.015, paste0('p=',p[1,2]), cex=cex1 )

dev.off()

#pdf('~/ridgeprs/paper/summary_eas_ukb.pdf',width=8,height=8)
pdf('~/ridgeprs/ridgePRS/text/summary_eas_ukb.pdf',width=8,height=8)
par(mar=c(4,5,3,1))
b <- barplot(eas.ci[4:1,1],ylim=c(0,max(eas.ci)+0.02), cex.lab=cex1, cex.axis=cex1,
             col=c(green[3],blue[3],purple[3],red[3]), xaxt='n', ylab="Average R2" )
axis( side=1, at=b, labels=c('PRSice-meta','CS-mult','PRS-CSx','BridgePRS'),
     cex.axis=cex1 )
arrows( x0=b, x1=b, y0=eas.ci[4:1,2], y1=eas.ci[4:1,3], code=3, angle=90 )
#mtext( 'c', side=3, adj=0, font=2, line=1, cex=cex2 )
mtext( 'East Asian target', side=3, adj=0.5, font=2, line=1, cex=cex2 )

p <- signif(pnorm(eas.t,lower.tail=FALSE)*2,2)

arrows( x0=b[2]+0.05, x1=b[3]-0.05,
       y0=max(eas.ci[2:3,3])+0.002, y1=max(eas.ci[2:3,3])+0.002,
       angle=90, code=3, length=0.05 )
text( x=(b[2]+b[3])/2, y=max(eas.ci[2:3,3])+0.005, paste0('p=',p[2,2] ), cex=cex1)

arrows( x0=b[3]+0.05, x1=b[4]-0.05,
       y0=max(eas.ci[1:2,3])+0.002, y1=max(eas.ci[1:2,3])+0.002,
       angle=90, code=3, length=0.05 )
text( x=(b[4]+b[3])/2, y=max(eas.ci[1:2,3])+0.005, paste0('p=',p[1,1]), cex=cex1 )

arrows( x0=b[2]+0.05, x1=b[4]-0.05,
       y0=max(eas.ci[1:3,3])+0.012, y1=max(eas.ci[1:3,3])+0.012,
       angle=90, code=3, length=0.05 )
text( x=b[3], y=max(eas.ci[1:2,3])+0.015, paste0('p=',p[1,2]), cex=cex1 )

dev.off()

cex1 <- 1.25
b <- 1:4
pdf('~/ridgeprs/paper/fig3a.pdf',width=8,height=8)
mx <- 0.16
boxplot( cbind( afr.prsice$V2, afr.cs$V2, afr.csx$V2, afr.ridge$V2 ),
        col=c(green[3],blue[3],purple[3],red[3]),
        xaxt='n', ylab="R2", boxwex=0.7, range=0, ylim=c(0,mx+0.005) )
beeswarm( as.data.frame(cbind( afr.prsice$V2, afr.cs$V2, afr.csx$V2, afr.ridge$V2 )),
         vertical=TRUE, add=TRUE, center=TRUE, corral="gutter", pch=20, cex=0.7 )
axis( side=1, at=b, labels=c('PRSice-meta','PRS-CS-mult','PRS-CSx','BridgePRS'),
     cex.axis=cex1 )
mtext( 'a', side=3, adj=0, font=2, line=1, cex=cex2 )

#p <- signif(pnorm(afr.t,lower.tail=FALSE)*2,2)

z <- (afr.cs$V2 - afr.csx$V2)/sqrt(afr.cs.se^2+afr.csx.se^2)
p <- signif( 2*pnorm( abs(sum(z)) / sqrt(length(z)), lower.tail=FALSE ),2)
arrows( x0=b[2]+0.05, x1=b[3]-0.05,
       y0=mx-0.015, y1=mx-0.015,
       angle=90, code=3, length=0.05 )
text( x=(b[2]+b[3])/2, y=mx-0.01, paste0('p=',p ), cex=cex1)

z <- (afr.ridge$V2 - afr.csx$V2)/sqrt(afr.ridge.se^2+afr.csx.se^2)
p <- signif( 2*pnorm( abs(sum(z)) / sqrt(length(z)), lower.tail=FALSE ),2)
arrows( x0=b[3]+0.05, x1=b[4]-0.05,
       y0=mx-0.015, y1=mx-0.015,
       angle=90, code=3, length=0.05 )
text( x=(b[4]+b[3])/2, y=mx-0.01, paste0('p=',p), cex=cex1 )

z <- (afr.cs$V2 - afr.ridge$V2)/sqrt(afr.ridge.se^2+afr.cs.se^2)
p <- signif( 2*pnorm( abs(sum(z)) / sqrt(length(z)), lower.tail=FALSE ),2)
arrows( x0=b[2]+0.05, x1=b[4]-0.05,
       y0=mx-0.005, y1=mx-0.005,
       angle=90, code=3, length=0.05 )
text( x=b[3], y=mx, paste0('p=',p), cex=cex1 )

dev.off()

pdf('~/ridgeprs/paper/fig3b.pdf',width=8,height=8)
mx <- 0.24
delta <- 0.007
boxplot( cbind( sas.prsice$V2, sas.cs$V2, sas.csx$V2, sas.ridge$V2 ),
        col=c(green[3],blue[3],purple[3],red[3]),
        xaxt='n', ylab="R2", boxwex=0.7, range=0, ylim=c(0,mx+delta) )
beeswarm( as.data.frame(cbind( sas.prsice$V2, sas.cs$V2, sas.csx$V2, sas.ridge$V2 )),
         vertical=TRUE, add=TRUE, center=TRUE, corral="gutter", pch=20, cex=0.7 )
axis( side=1, at=b, labels=c('PRSice-meta','PRS-CS-mult','PRS-CSx','BridgePRS'),
     cex.axis=cex1 )
mtext( 'b', side=3, adj=0, font=2, line=1, cex=cex2 )

#p <- signif(pnorm(sas.t,lower.tail=FALSE)*2,2)

z <- (sas.cs$V2 - sas.csx$V2)/sqrt(sas.cs.se^2+sas.csx.se^2)
p <- signif( 2*pnorm( abs(sum(z)) / sqrt(length(z)), lower.tail=FALSE ),2)
arrows( x0=b[2]+0.05, x1=b[3]-0.05,
       y0=mx-delta*3, y1=mx-delta*3,
       angle=90, code=3, length=0.05 )
text( x=(b[2]+b[3])/2, y=mx-delta*2, paste0('p=',p ), cex=cex1)

z <- (sas.ridge$V2 - sas.csx$V2)/sqrt(sas.ridge.se^2+sas.csx.se^2)
p <- signif( 2*pnorm( abs(sum(z)) / sqrt(length(z)), lower.tail=FALSE ),2)
arrows( x0=b[3]+0.05, x1=b[4]-0.05,
       y0=mx-delta*3, y1=mx-delta*3,
       angle=90, code=3, length=0.05 )
text( x=(b[4]+b[3])/2, y=mx-delta*2, paste0('p=',p), cex=cex1 )

z <- (sas.cs$V2 - sas.ridge$V2)/sqrt(sas.ridge.se^2+sas.cs.se^2)
p <- signif( 2*pnorm( abs(sum(z)) / sqrt(length(z)), lower.tail=FALSE ),2)
arrows( x0=b[2]+0.05, x1=b[4]-0.05,
       y0=mx-delta, y1=mx-delta,
       angle=90, code=3, length=0.05 )
text( x=b[3], y=mx, paste0('p=',p), cex=cex1 )

dev.off()


pdf('~/ridgeprs/paper/fig3c.pdf',width=8,height=8)
mx <- 0.26
boxplot( cbind( eas.prsice$V2, eas.cs$V2, eas.csx$V2, eas.ridge$V2 ),
        col=c(green[3],blue[3],purple[3],red[3]),
        xaxt='n', ylab="R2", boxwex=0.7, range=0, ylim=c(0,mx+delta) )
beeswarm( as.data.frame(cbind( eas.prsice$V2, eas.cs$V2, eas.csx$V2, eas.ridge$V2 )),
         vertical=TRUE, add=TRUE, center=TRUE, corral="gutter", pch=20, cex=0.7 )
axis( side=1, at=b, labels=c('PRSice-meta','PRS-CS-mult','PRS-CSx','BridgePRS'),
     cex.axis=cex1 )
mtext( 'c', side=3, adj=0, font=2, line=1, cex=cex2 )

#p <- signif(pnorm(eas.t,lower.tail=FALSE)*2,2)

z <- (eas.cs$V2 - eas.csx$V2)/sqrt(eas.cs.se^2+eas.csx.se^2)
p <- signif( 2*pnorm( abs(sum(z)) / sqrt(length(z)), lower.tail=FALSE ),2)
arrows( x0=b[2]+0.05, x1=b[3]-0.05,
       y0=mx-delta*3, y1=mx-delta*3,
       angle=90, code=3, length=0.05 )
text( x=(b[2]+b[3])/2, y=mx-delta*2, paste0('p=',p ), cex=cex1)

z <- (eas.ridge$V2 - eas.csx$V2)/sqrt(eas.ridge.se^2+eas.csx.se^2)
p <- signif( 2*pnorm( abs(sum(z)) / sqrt(length(z)), lower.tail=FALSE ),2)
arrows( x0=b[3]+0.05, x1=b[4]-0.05,
       y0=mx-delta*3, y1=mx-delta*3,
       angle=90, code=3, length=0.05 )
text( x=(b[4]+b[3])/2, y=mx-delta*2, paste0('p=',p), cex=cex1 )

z <- (eas.cs$V2 - eas.ridge$V2)/sqrt(eas.ridge.se^2+eas.cs.se^2)
p <- signif( 2*pnorm( abs(sum(z)) / sqrt(length(z)), lower.tail=FALSE ),2)
arrows( x0=b[2]+0.05, x1=b[4]-0.05,
       y0=mx-delta, y1=mx-delta,
       angle=90, code=3, length=0.05 )
text( x=b[3], y=mx, paste0('p=',p), cex=cex1 )

dev.off()

afr <- as.data.frame(afr)
sas <- as.data.frame(sas)
eas <- as.data.frame(eas)
t.test( (afr$ridge - afr$csx)/sqrt(afr.ridge.se^2+afr.csx.se^2), var.equal=TRUE )
t.test( (sas$ridge - sas$csx)/sqrt(sas.ridge.se^2+sas.csx.se^2), var.equal=TRUE )
t.test( (eas$ridge - eas$csx)/sqrt(eas.ridge.se^2+eas.csx.se^2), var.equal=TRUE )
