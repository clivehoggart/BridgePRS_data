library(data.table)

outlier <- function( x, n.sd ){
    s <- sd(x,na.rm=TRUE)
    ptr.rm <- which( -s*n.sd > x | x > s*n.sd )
    return(ptr.rm)
}

vital <- fread("/sc/arion/projects/rg_kennye02/chois26/data/BioMe/BRSPD/Questionnaire.txt",data.table=FALSE)
bmi <- fread('/sc/arion/projects/rg_kennye02/chois26/BMI.csv')
cnames <- fread('/sc/arion/projects/rg_kennye02/hoggac01/questionaire_header.txt')
colnames(vital) <- colnames(cnames)
blood <- fread('~/biome/Bcx3_06232021.csv')

ptr <- match( bmi$rgnid, vital$rgnid )
vital <- vital[ptr,]
ptr <- match( bmi$ID_1, blood$MASKED_MRN )
blood <- blood[ptr,]

sas.ids <- fread("/sc/arion/projects/rg_kennye02/hoggac01/SAS_ids.txt")
afr.ids <- fread("/sc/arion/projects/rg_kennye02/hoggac01/AFR_ids.txt")
ptr.sas <- match( sas.ids$V1, bmi$ID_1 )
ptr.afr <- match( afr.ids$V1, bmi$ID_1 )

png('~/biome/blood_hist.png', width=600, height=400 )
par(mfrow=c(2,3))

fit <- lm( blood$MCV ~ vital$GENDER + bmi$Age )
hist(fit$residuals)
ids.used <- bmi$ID_1[-fit$na.action]
ids.mcv <- ids.used[ -outlier( fit$residuals, 3 ) ]

fit <- lm( log(blood$PLT_COUNT) ~ vital$GENDER + bmi$Age )
hist(fit$residuals)
ids.used <- bmi$ID_1[-fit$na.action]
ids.plt <- ids.used[ -outlier( fit$residuals, 3 ) ]

fit <- lm( log(blood$MONOCYTE+0.1) ~ vital$GENDER + bmi$Age )
hist(fit$residuals)
ids.used <- bmi$ID_1[-fit$na.action]
ids.mono <- ids.used[ -outlier( fit$residuals, 3 ) ]

fit <- lm( log(blood$NEUTROPHIL) ~ vital$GENDER + bmi$Age )
hist(fit$residuals)
ids.used <- bmi$ID_1[-fit$na.action]
ids.neutro <- ids.used[ -outlier( fit$residuals, 3 ) ]

fit <- lm( log(blood$RDW) ~ vital$GENDER + bmi$Age )
hist(fit$residuals)
ids.used <- bmi$ID_1[-fit$na.action]
ids.rdw <- ids.used[ -outlier( fit$residuals, 3 ) ]

ids.eos <- blood$MASKED_MRN[ which(blood$EOSINOPHIL<0.6) ]

dev.off()

ids.used <- unique( c(ids.mcv, ids.plt, ids.mono, ids.rdw, ids.neutro, ids.eos ) )
tmp <- blood[match( ids.used, blood$MASKED_MRN),]
ptr.bmi <- match( ids.used, bmi$ID_1 )
blood.clean <- data.frame( bmi$rgnid[ptr.bmi], ids.used,
                          matrix(nrow=length(ids.used),ncol=6) )
colnames(blood.clean) <- c("rgnid","ID_1","mcv","plt","mono","neutro","eos","rdw")

ptr <- match( ids.mcv, ids.used )
blood.clean$mcv[ptr] <- tmp$MCV[ptr]

ptr <- match( ids.plt, ids.used )
blood.clean$plt[ptr] <- tmp$PLT_COUNT[ptr]

ptr <- match( ids.mono, ids.used )
blood.clean$mono[ptr] <- tmp$MONOCYTE[ptr]

ptr <- match( ids.neutro, ids.used )
blood.clean$neutro[ptr] <- tmp$NEUTROPHIL[ptr]

ptr <- match( ids.eos, ids.used )
blood.clean$eos[ptr] <- tmp$EOSINOPHIL[ptr]

ptr <- match( ids.rdw, ids.used )
blood.clean$rdw[ptr] <- tmp$RDW[ptr]

write.table( blood.clean, '/sc/arion/projects/rg_kennye02/hoggac01/blood.dat',
            quote=FALSE, row.names=FALSE )

hist(x$MCV)
hist(log(x$PLT_COUNT))
hist(log(x$MONOCYTE))
hist(log(x$NEUTROPHIL))
hist(log(x$EOSINOPHIL))
hist(log(x$RDW))
