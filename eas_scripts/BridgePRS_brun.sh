#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J Bridge[1-13]
#BSUB -R "span[hosts=1]"
#BSUB -q premium
#BSUB -W 12:00
#BSUB -P acc_psychgen
#BSUB -o Bridge.o%J.%I
#BSUB -eo Bridge.e%J.%I
#BSUB -M 20000

module load R/4.1.0

i=${LSB_JOBINDEX}-1

phenos=( 50     21001 30610 30220 30710 30150  30780 30040 30130 30140  30080 30870 30860)
phenos2=(Height BMI   ALP   Baso  CRP   Eosino LDL-C MCV   Mono  Neutro Plt   TG    TP)
pheno=${phenos[$i]}
pheno2=${phenos2[$i]}

pop1=EUR
pop11=eur
pop2=EAS
pop22=eas

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/imputed

cov_names="Age,Sex,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,PC11,PC12,PC13,PC14,PC15,PC16,PC17,PC18,PC19,PC20,PC21,PC22,PC23,PC24,PC25,PC26,PC27,PC28,PC29,PC30,PC31,PC32,PC33,PC34,PC35,PC36,PC37,PC38,PC39,PC40"
type=normal
if [ $pheno = 30780 ] || [ $pheno = 30610 ] || [ $pheno = 30630 ] || [ $pheno = 30710 ] || [ $pheno = 30770 ] || [ $pheno = 30650 ] || [ $pheno = 30810 ] || [ $pheno = 30870 ] || [ $pheno = 30670 ] || [ $pheno = 30750 ] || [ $pheno = 30860 ] || [ $pheno = 30890 ]
then
    type=bloodbc
    cov_names="Age,Sex,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10,PC11,PC12,PC13,PC14,PC15,PC16,PC17,PC18,PC19,PC20,PC21,PC22,PC23,PC24,PC25,PC26,PC27,PC28,PC29,PC30,PC31,PC32,PC33,PC34,PC35,PC36,PC37,PC38,PC39,PC40,Fasting,Dilution"
fi

bfile=/sc/arion/projects/psychgen/ukb/usr/clive/ukb/imputed/chr
ld_bfile=/sc/arion/projects/psychgen/ukb/usr/clive/ukb/imputed/chr
pop1_ld_ids=/sc/arion/projects/psychgen/ukb/usr/clive/ukb/ld_ids.txt
pop2_ld_ids=/sc/arion/projects/psychgen/ukb/usr/clive/ukb/eas_ids.txt

pheno_stem=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype

~/BridgePRS/bin/BridgePRS.sh \
    --ranking f.stat \
    --bfile $bfile \
    --indir /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/imputed/test11/$pheno \
    --outdir /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ/ukb_ld/$pheno \
    --strand_check 1 \
    --pop1 $pop11 \
    --pop2 $pop2 \
    --pop1_sumstats /sc/arion/projects/psychgen/ukb/usr/clive/ukb/impute_gwas/$pheno/EUR.chr \
    --pop2_sumstats /sc/arion/projects/psychgen/ukb/usr/clive/BBJ/download/BBJ.$pheno2.autosome.txt.gz \
    --pop1_ld_bfile $bfile \
    --pop2_ld_bfile $bfile \
    --pop1_ld_ids $pop1_ld_ids \
    --pop2_ld_ids $pop2_ld_ids \
    --pop2_test_data /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/${pheno}/EAS-${pheno}-test.dat \
    --pop2_valid_data /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/${pheno}/EAS-${pheno}-valid.dat \
    --fst 0.101493 \
    --cov_names $cov_names \
    --pheno_name Phenotype \
    --by_chr TRUE \
    --sumstats_snpID SNP \
    --sumstats_p P \
    --sumstats_beta beta.real \
    --sumstats_allele1 ALT \
    --sumstats_allele0 REF \
    --sumstats_n N \
    --sumstats_se se.real \
    --sumstats_frq Frq \
    --ld_shrink 0 \
    --n_cores 4 \
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

