library(data.table)
covs <- fread('/sc/arion/projects/psychgen/ukb/usr/clive/ukb/covar.dat')
height <- fread('Height/Height.dat')
q.height <- fread('Height/pheno.dat')

height <- height[match(q.height$IID,height$IID),]
covs <- covs[match(q.height$IID,covs$IID),]

m <- tapply(height$Height,covs$Sex,mean)
s <- tapply(height$Height,covs$Sex,sd)

w <- 3
ptr.keep <- c( which( m[1]-w*s[1] < height$Height&height$Height < m[1]+w*s[1] & covs$Sex==0 ),
              which( m[2]-w*s[2] < height$Height&height$Height < m[2]+w*s[2] & covs$Sex==1 ) )
write.table(height[ptr.keep,],'Height/height_3sd.dat',quote=FALSE,row.names=FALSE)
