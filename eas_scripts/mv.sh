pheno=( 50     21001 30610 30220 30710 30150  30780 30040 30130 30140  30080 30870 30860)
for i in {0..12}
do
    for chr in {1..22}
    do
	dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ/ukb_ld/
	mv $dir/${pheno[$i]}/models/eas_stage2_beta_bar_chr4.txt.gz $dir/${pheno[$i]}/models/EAS_stage2_beta_bar_chr4.txt.gz
	mv $dir/${pheno[$i]}/models/eas_stage2_KLdist_chr4.txt.gz $dir/${pheno[$i]}/models/EAS_stage2_KLdist_chr4.txt.gz
    done
done
