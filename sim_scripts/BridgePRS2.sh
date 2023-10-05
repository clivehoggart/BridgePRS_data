ld_bfile=/sc/arion/projects/data-ark/1000G/phase3/PLINK/chr

pop1=eur
pop2=afr
pop11=EUR
pop22=AFR

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen

for i in {1..15}
do
    pheno=SCORE${i}_AVG
    ~/BridgePRS/bin/BridgePRS.sh \
	--outdir $dir/Bridge/$pheno \
	--strand_check 1 \
	--pop1 $pop1 \
	--pop2 $pop2 \
	--pop1_sumstats $dir/gwas/${pop1}_chr \
	--pop2_sumstats $dir/gwas/${pop2}_chr \
	--by_chr_sumstats .$pheno.glm.linear.gz \
	--pop1_bfile $dir/output/${pop1}_chr \
	--pop1_ld_bfile $ld_bfile \
	--pop1_ld_ids ~/BridgePRS/data/${pop11}_IDs.txt \
	--pop2_bfile $dir/output/${pop2}_chr \
	--pop2_ld_bfile $ld_bfile \
	--pop2_ld_ids ~/BridgePRS/data/${pop22}_IDs.txt \
	--pop1_test_data $dir/scores/${pheno}_${pop1}_test.dat \
	--pop2_test_data $dir/scores/${pheno}_${pop2}_test.dat \
	--pop2_valid_data $dir/scores/${pheno}_${pop2}_valid.dat \
	--fst 0.15 \
	--cov_names 000 \
	--pheno_name $pheno \
	--by_chr TRUE \
	--sumstats_snpID ID \
	--sumstats_p P \
	--sumstats_beta BETA \
	--sumstats_allele1 ALT \
	--sumstats_allele0 REF \
	--sumstats_n OBS_CT \
	--sumstats_se SE \
	--sumstats_frq A1_FREQ \
	--ld_shrink 0 \
	--n_cores 30 \
	--do_clump_pop1 0 \
	--do_est_beta_pop1 0 \
	--do_predict_pop1 0 \
	--do_est_beta_pop1_precision 0 \
	--do_est_beta_InformPrior 1 \
	--do_predict_pop2_stage2 1 \
	--do_clump_pop2 0 \
	--do_est_beta_pop2 1 \
	--do_predict_pop2 1 \
	--do_combine 1
done

