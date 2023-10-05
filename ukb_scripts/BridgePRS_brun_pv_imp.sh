#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J Bridge[1-3]
#BSUB -R "span[hosts=1]"
#BSUB -q premium
#BSUB -W 6:00
#BSUB -P acc_psychgen
#BSUB -o Bridge.o%J.%I
#BSUB -eo Bridge.e%J.%I
#BSUB -M 20000

module load R/4.1.0

phenos=(50 21001 30080 30710 30140 30040 30630 30240 30610 30780 30130 30070 30670 30870 30220 30860 30530 30770 30150)

pop1=EUR
pop11=eur

if [ ${LSB_JOBINDEX} -lt 20 ]
then
    pop2=AFR
    pop22=afr
    pop222=afr
    i=${LSB_JOBINDEX}-1
    fst=0.15
fi
if [ ${LSB_JOBINDEX} -gt 19 ]
then
    pop2=SAS
    pop22=SAS
    pop222=sas
    i=$((${LSB_JOBINDEX}-20))
    fst=0.03
fi

pop2=SAS
pop22=SAS
pop222=sas
i=$((${LSB_JOBINDEX}-1))
fst=0.03
phenos=(30610 30780 30150)

pheno=${phenos[$i]}
dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/imputed
indir=$dir/test11/$pheno
outdir=$dir/test12/$pheno

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
pop2_ld_ids=/sc/arion/projects/psychgen/ukb/usr/clive/ukb/${pop222}_train_ids.txt

pheno_stem=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype

~/BridgePRS/bin/BridgePRS2.sh \
    --ranking pv \
    --bfile $bfile \
    --indir $indir \
    --outdir $outdir \
    --strand_check 0 \
    --pop1 $pop11 \
    --pop2 $pop22 \
    --pop1_sumstats /sc/arion/projects/psychgen/ukb/usr/clive/ukb/impute_gwas/$pheno/EUR.chr \
    --pop2_sumstats /sc/arion/projects/psychgen/ukb/usr/clive/ukb/impute_gwas/$pheno/$pop2.chr \
    --by_chr_sumstats .Phenotype.glm.linear.gz \
    --pop1_ld_bfile $bfile \
    --pop2_ld_bfile $bfile \
    --pop1_ld_ids $pop1_ld_ids \
    --pop2_ld_ids $pop2_ld_ids \
    --pop1_test_data $pheno_stem/$pheno/$pheno-EUR-$type-trim.target \
    --pop2_test_data $pheno_stem/$pheno/$pheno-$pop2-$type-trim.target \
    --pop2_valid_data $pheno_stem/$pheno/$pheno-$pop2-$type-trim.valid \
    --fst $fst \
    --cov_names $cov_names \
    --pheno_name Phenotype \
    --by_chr TRUE \
    --sumstats_snpID ID \
    --sumstats_p P \
    --sumstats_beta BETA \
    --sumstats_allele1 A1 \
    --sumstats_allele0 AX \
    --sumstats_n OBS_CT \
    --sumstats_se SE \
    --sumstats_frq A1_FREQ \
    --ld_shrink 0 \
    --n_cores 4 \
    --do_clump_pop1 0 \
    --do_est_beta_pop1 0 \
    --do_predict_pop1 0 \
    --do_est_beta_pop1_precision 0 \
    --do_est_beta_InformPrior 1 \
    --do_predict_pop2_stage2 1 \
    --do_clump_pop2 0 \
    --do_est_beta_pop2 0 \
    --do_predict_pop2 0 \
    --do_combine 1
