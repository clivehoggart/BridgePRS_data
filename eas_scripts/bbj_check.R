options(stringsAsFactors=FALSE)
height <- fread('BBJ.Height.autosome.txt.gz')
plt <- fread('BBJ.Plt.autosome.txt.gz')

height.ukb <- fread('/sc/arion/projects/psychgen/ukb/usr/clive/ukb/impute_gwas/50/EUR.chr1.Phenotype.glm.linear.gz')
plt.ukb <- fread('/sc/arion/projects/psychgen/ukb/usr/clive/ukb/impute_gwas/30140/EUR.chr1.Phenotype.glm.linear.gz')

snps.plt <- intersect(plt$SNP,plt.ukb$ID)
snps.height <- intersect(height$SNP,height.ukb$ID)

ptr.height.ukb <- match(snps.height,height.ukb$ID)
ptr.height.bbj <- match(snps.height,height$SNP)
height.ukb[ptr.height.ukb[1:5],]
height[ptr.height.bbj[1:5],]

ptr.plt.ukb <- match(snps.plt,plt.ukb$ID)
ptr.plt.bbj <- match(snps.plt,plt$SNP)
plt.ukb[ptr.plt.ukb[1:5],]
plt[ptr.plt.bbj[1:5],]

model.plt <- fread('/sc/arion/work/hoggac01/ukb_pheno_results/30140/test_imputed/models/eur_beta_bar_chr1.txt.gz')
model.plt.stage2 <- fread("/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ/test/30140/models/EAS_stage2_beta_bar_chr1.txt.gz")
ptr.gwas <- match( model.plt.stage2$snp, plt$SNP )
ptr.model <- match( model.plt.stage2$snp, model.plt$snp )
table( paste(model.plt$ref.allele,model.plt$effect.allele)[ptr.model], paste(plt$REF,plt$ALT)[ptr.gwas] )

model.height <- fread('/sc/arion/work/hoggac01/ukb_pheno_results/50/test_imputed/models/eur_beta_bar_chr1.txt.gz')
model.height.stage2 <- fread("/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ/test/50/models/EAS_stage2_beta_bar_chr1.txt.gz")
ptr.gwas <- match( model.height.stage2$snp, height$SNP )
ptr.model <- match( model.height.stage2$snp, model.height$snp )
table( paste(model.height$ref.allele,model.height$effect.allele)[ptr.model], paste(height$REF,height$ALT)[ptr.gwas] )


ptr <- which(plt$P[ptr.gwas]<1e-2)
beta.bbj <- ifelse( model.plt$effect.allele[ptr.model]==plt$ALT[ptr.gwas],
                   plt$beta.real, -plt$beta.real )
