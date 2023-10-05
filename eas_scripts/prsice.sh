#       1      1     0     1     0     1      0     1     1     1       1     0     0
#       0      1     2     3     4     5      6     7     8     9      10    11    12
pheno=( 50     21001 30610 30220 30710 30150  30780 30040 30130 30140  30080 30870 30860)
pheno2=(Height BMI   ALP   Baso  CRP   Eosino LDL-C MCV   Mono  Neutro Plt   TG    TP)


for i in {7..12}
do
    outdir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ/test/${pheno[$i]}
    mkdir $outdir
    sumstats=/sc/arion/projects/psychgen/ukb/usr/clive/BBJ/BBJ.${pheno2[$i]}.autosome.txt.gz
    target=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/${pheno[$i]}/EAS-test.dat
    valid=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/${pheno[$i]}/EAS-valid.dat

    Rscript ~/prsice/PRSice.R --dir . \
	    --prsice ~/prsice/PRSice_linux \
	--ultra \
	--out /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ/test/${pheno[$i]}/prsice \
        --base $sumstats \
        --snp SNP --chr CHR --bp POS --A1 ALT --A2 REF --stat beta.real --pvalue P \
        --target /sc/arion/projects/psychgen/ukb/usr/clive/ukb/imputed/chr# \
        --pheno /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/${pheno[$i]}/EAS-test.dat \
        --keep /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/${pheno[$i]}/EAS-all.dat \
        --cov /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/${pheno[$i]}/EAS-test.dat \
	--extract /sc/arion/projects/psychgen/ukb/usr/clive/BBJ/bbj.snplist \
	--cov-col Age,Sex,@PC[1-40] \
	--pheno-col Phenotype \
	--ld /sc/arion/projects/data-ark/1000G/phase3/PLINK/chr# \
	--ld-keep ~/BridgePRS/1000G_EAS_ids.txt \
	--thread 30 \
        --beta \
	--binary-target F
done

