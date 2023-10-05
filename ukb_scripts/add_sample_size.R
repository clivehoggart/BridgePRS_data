library(data.table)

args <- commandArgs(trailingOnly=TRUE)
sumstats.file <- args[1]
params.file <- args[2]

params <- read.table(params.file,header=TRUE)
sumstats <- fread(sumstats.file)
N <- median(sumstats$OBS_CT)
params <- cbind( params, N )
write.table( params, params.file, row.names=FALSE, quote=FALSE )
