kl=fread("/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/test/30140/models/EAS_stage2_KLdist_chr1.txt.gz")

eur=fread('/sc/arion/projects/psychgen/ukb/usr/clive/ukb/impute_gwas/30140/EUR.chr1.Phenotype.glm.linear.gz')

eas=fread('/sc/arion/projects/psychgen/ukb/usr/clive/BBJ/BBJ.Plt.autosome.txt.gz')

ptr.eur <- match( kl$clumnp.id, eur$ID )
ptr.eas <- match( kl$clumnp.id, eas$SNP )
