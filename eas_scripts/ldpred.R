library(bigsnpr)
options(bigstatsr.check.parallel.blas = FALSE)
options(default.nproc.blas = NULL)
library(data.table)
library(magrittr)
library(runonce)

pheno <- c(50, 21001, 30610, 30220, 30710, 30150, 30780, 30040, 30130, 30140, 30080, 30870, 30860)
pheno2 <- c("Height", "BMI", "ALP", "Baso", "CRP", "Eosino", "LDL-C", "MCV", "Mono", "Neutro", "Plt", "TG", "TP")

info <- readRDS(runonce::download_file(
  "https://ndownloader.figshare.com/files/25503788",
  fname = "map_hm3_ldpred2.rds"))

i <- 1
infile <- paste0("/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/",pheno[i],"/EAS-test.dat")
data <- fread(infile)
infile <- paste0("/sc/arion/projects/psychgen/ukb/usr/clive/BBJ/BBJ.",pheno2[i],".autosome.txt.gz")
sumstats <- fread(infile,data.table=FALSE)
sumstats <- sumstats[,c("CHR","POS","rsid","ALT","REF","N","BETA","SE","P","MAF")]
names(sumstats) <-
    c("chr",
    "pos",
    "rsid",
    "a1",
    "a0",
    "n_eff",
    "beta",
    "beta_se",
    "p",
    "MAF")
sumstats <- sumstats[ sumstats$rsid %in% info$rsid, ]

NCORES <- nb_cores()
tmp <- tempfile(tmpdir = "tmp-data")
on.exit(file.remove(paste0(tmp, ".sbk")), add = TRUE)
corr <- NULL
ld <- NULL
# We want to know the ordering of samples in the bed file
fam.order <- NULL

fam <- fread("/sc/arion/projects/psychgen/ukb/usr/clive/ukb/imputed/chr1.fam")
bim <- fread("/sc/arion/projects/psychgen/ukb/usr/clive/ukb/imputed/chr1.bim")
qc <- fread("/sc/arion/projects/psychgen/ukb/usr/clive/ukb/imputed/chr1.qced.snps",header=FALSE)

snps <- intersect( qc$V1, sumstats$rsid )
ptr.snps <- match( snps, bim$V2 )
ptr.ids <- match( data$IID, fam$V2 )

# preprocess the bed file (only need to do once for each data set)
snp_readBed("/sc/arion/projects/psychgen/ukb/usr/clive/ukb/imputed/chr1.bed",
            backingfile="tmp-data/chr1", ind.row=ptr.ids, ind.col=ptr.snps )
# now attach the genotype object
obj.bigSNP <- snp_attach("EUR.QC.rds")
# extract the SNP information from the genotype
map <- obj.bigSNP$map[-3]
names(map) <- c("chr", "rsid", "pos", "a1", "a0")
# perform SNP matching
info_snp <- snp_match(sumstats, map)
