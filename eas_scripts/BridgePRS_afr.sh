#       1      1     0     1     0     1      0     1     1     1       1     0     0
#       0      1     2     3     4     5      6     7     8     9      10    11    12
pheno=( 50     21001 30610 30220 30710 30150  30780 30040 30130 30140  30080 30870 30860)
pheno2=(Height BMI   ALP   Baso  CRP   Eosino LDL-C MCV   Mono  Neutro Plt   TG    TP)

#eas_ld_bfile=/sc/arion/projects/psychgen/ukb/usr/clive/ukb/imputed/chr
#eas_ld_ids=/sc/arion/projects/psychgen/ukb/usr/clive/ukb/eas_train_ids.txt

eas_ld_bfile=/sc/arion/projects/data-ark/1000G/phase3/PLINK/chr
eas_ld_ids=~/BridgePRS/data/EAS_IDs.txt

N_pop1=11315
N_pop2=15899
N_JPT=11600
recomb_pop2_file=/sc/arion/projects/psychgen/ukb/usr/clive/recombination/YRI/YRI
recomb_pop1_file=/sc/arion/projects/psychgen/ukb/usr/clive/recombination/JPT/JPT
ld_shrink=0

pop1=EAS
pop2=AFR

ptr_type=(6 2 4 11 12)
for i in "${ptr_type[@]}"
#for i in {1..12}
do
    cov_names=Age,Sex,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,PC11,PC12,PC13,PC14,PC15,PC16,PC17,PC18,PC19,PC20,PC21,PC22,PC23,PC24,PC25,PC26,PC27,PC28,PC29,PC30,PC31,PC32,PC33,PC34,PC35,PC36,PC37,PC38,PC39,PC40
    if [ ${pheno[$i]} = 30780 ] || [ ${pheno[$i]} = 30610 ] || [ ${pheno[$i]} = 30710 ] || [ ${pheno[$i]} = 30870 ] || [ ${pheno[$i]} = 30860 ]
    type=normal
    then
	cov_names=$cov_names,Fasting,Dilution
        type=bloodbc
    fi
    ~/BridgePRS/bin/BridgePRS.sh \
	--indir /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ/1000G_ld/${pheno[$i]} \
	--outdir /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ/test/${pheno[$i]} \
	--strand_check 1 \
	--pop1 ${pop1} \
	--pop2 ${pop2} \
	--pop2_sumstats /sc/arion/projects/psychgen/ukb/usr/clive/ukb/impute_gwas/${pheno[$i]}/${pop2}.chr \
	--pop1_sumstats /sc/arion/projects/psychgen/ukb/usr/clive/BBJ/BBJ.${pheno2[$i]}.autosome.txt.gz \
	--pop1_bfile /sc/arion/projects/psychgen/ukb/usr/clive/ukb/imputed/chr \
	--pop2_bfile /sc/arion/projects/psychgen/ukb/usr/clive/ukb/imputed/chr \
	--pop2_ld_bfile /sc/arion/projects/psychgen/ukb/usr/clive/ukb/imputed/chr \
	--pop2_ld_ids /sc/arion/projects/psychgen/ukb/usr/clive/ukb/afr_train_ids.txt \
	--pop1_ld_bfile $eas_ld_bfile \
	--pop1_ld_ids $eas_ld_ids \
	--pop2_test_data /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/${pheno[$i]}/${pheno[$i]}-${pop2}-$type-trim.target \
	--pop2_valid_data /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/${pheno[$i]}/${pheno[$i]}-${pop2}-$type-trim.valid \
	--pop1_test_data /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/${pheno[$i]}/EAS-test.dat \
	--pop1_valid_data /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/${pheno[$i]}/EAS-valid.dat \
	--cov_names $cov_names \
	--pheno_name Phenotype \
	--by_chr 1 \
	--sumstats_snpID ID \
	--sumstats_p P \
	--sumstats_beta BETA \
	--sumstats_allele1 A1 \
	--sumstats_allele0 AX \
	--sumstats_n OBS_CT \
	--sumstats_se SE \
	--sumstats_frq A1_FREQ \
	--N_pop1 $N_pop1 \
	--N_pop2 $N_pop2 \
	--ld_shrink $ld_shrink \
	--recomb_pop1_file $recomb_pop1_file \
	--recomb_pop2_file $recomb_pop2_file \
        --by_chr_ld TRUE \
        --by_chr_target TRUE \
	--by_chr_sumstats .Phenotype.glm.linear.gz \
        --fst 0.15 \
	--n_cores 30 \
	--do_clump_pop1 0 \
	--do_est_beta_pop1 0 \
	--do_predict_pop1 0 \
	--do_est_beta_pop1_precision 0 \
	--do_est_beta_InformPrior 0 \
	--do_predict_pop2_stage2 1 \
	--do_clump_pop2 0 \
	--do_est_beta_pop2 0 \
	--do_predict_pop2 0 \
	--do_combine 0
done

