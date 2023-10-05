phenos=(50 21001 30080 30710 30140 30040 30630 30240 30610 30780 30130 30070 30670 30870 30220 30860 30530 30770 30150)

pop2=AFR

for i in {0..18}
do
    pheno=${phenos[$i]}
    cov_names=Age,Sex,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,PC11,PC12,PC13,PC14,PC15,PC16,PC17,PC18,PC19,PC20,PC21,PC22,PC23,PC24,PC25,PC26,PC27,PC28,PC29,PC30,PC31,PC32,PC33,PC34,PC35,PC36,PC37,PC38,PC39,PC40
    type=normal
    if [ $pheno = 30780 ] || [ $pheno = 30610 ] || [ $pheno = 30630 ] || [ $pheno = 30710 ] || [ $pheno = 30770 ] || [ $pheno = 30650 ] || [ $pheno = 30810 ] || [ $pheno = 30870 ] || [ $pheno = 30670 ] || [ $pheno = 30750 ] || [ $pheno = 30860 ] || [ $pheno = 30890 ]
    then
	cov_names=$cov_names,Fasting,Dilution
	type=bloodbc
    fi
    ~/BridgePRS/bin/BridgePRS2.sh \
	--outdir /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/geno/test1/$pheno \
	--pop1 EUR \
	--pop2 $pop2 \
	--pop2_test_data /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/$pheno/$pheno-$pop2-$type-trim.target \
	--pop2_valid_data /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/$pheno/$pheno-$pop2-$type-trim.valid \
	--cov_names $cov_names \
	--pheno_name Phenotype \
	--n_cores 30 \
	--do_clump_pop1 0 \
	--do_est_beta_pop1 0 \
	--do_predict_pop1 0 \
	--do_est_beta_pop1_precision 0 \
	--do_est_beta_InformPrior 0 \
	--do_predict_pop2_stage2 0 \
	--do_clump_pop2 0 \
	--do_est_beta_pop2 0 \
	--do_predict_pop2 0 \
	--do_combine 1
done
