#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J Bridge[1-60]
#BSUB -R "span[hosts=1]"
#BSUB -q premium
#BSUB -W 12:00
#BSUB -P acc_psychgen
#BSUB -o Bridge.o%J.%I
#BSUB -eo Bridge.e%J.%I
#BSUB -M 20000

module load R/4.1.0

#chr=${LSB_JOBINDEX}

pop1=eur
pop11=EUR

#pop2=afr
#pop22=AFR
#fst=0.15
#eur_fit=1
    pop2=eas
    pop22=EAS
    eur_fit=0
    fst=0.11

if [ ${LSB_JOBINDEX} -lt 31 ]
then
    i=${LSB_JOBINDEX}
    causal=with_causal
fi
if [ ${LSB_JOBINDEX} -gt 30 ]
then
    causal=wo_causal
    i=$((${LSB_JOBINDEX}-30))
fi

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen
pheno=SCORE${i}_AVG

ref_panel=1000G

if [ $ref_panel = 1000G ]
then
    ld_bfile=/sc/arion/projects/data-ark/1000G/phase3/PLINK/chr
    pop1_ld_ids=~/BridgePRS/data/${pop11}_IDs.txt
    pop2_ld_ids=~/BridgePRS/data/${pop22}_IDs.txt
    outdir=$dir/Bridge/herit50_half_n/$causal/$pheno
    gwas_dir=gwas50_half_n
    pheno_dir=scores50_half_n
fi
if [ $ref_panel = ukb ]
then
    ld_bfile=/sc/arion/projects/psychgen/ukb/usr/clive/ukb/imputed/chr
    pop1_ld_ids=/sc/arion/projects/psychgen/ukb/usr/clive/ukb/ld_ids.txt
    pop2_ld_ids=/sc/arion/projects/psychgen/ukb/usr/clive/ukb/${pop2}_ids.txt
    outdir=$dir/Bridge/ukb_ref/$causal/$pheno
    gwas_dir=gwas
    pheno_dir=scores
fi

~/BridgePRS/bin/BridgePRS.sh \
    --indir $outdir \
    --outdir $outdir \
    --strand_check 1 \
    --pop1 $pop1 \
    --pop2 $pop2 \
    --pop1_sumstats $dir/$gwas_dir/${pop1}_chr \
    --pop2_sumstats $dir/$gwas_dir/${pop2}_chr \
    --by_chr_sumstats .${pheno}.glm.linear.gz \
    --pop1_bfile $dir/output/${pop1}_chr \
    --pop2_bfile $dir/output/${pop2}_chr \
    --pop1_ld_bfile $ld_bfile \
    --pop2_ld_bfile $ld_bfile \
    --pop1_ld_ids $pop1_ld_ids \
    --pop2_ld_ids $pop2_ld_ids \
    --pop1_test_data $dir/$pheno_dir/${pheno}_${pop1}_test.dat \
    --pop2_test_data $dir/$pheno_dir/${pheno}_${pop2}_test.dat \
    --pop2_valid_data $dir/$pheno_dir/${pheno}_${pop2}_valid.dat \
    --fst $fst \
    --cov_names 000 \
    --pheno_name $pheno \
    --by_chr 1 \
    --sumstats_snpID ID \
    --sumstats_p P \
    --sumstats_beta BETA \
    --sumstats_allele1 ALT \
    --sumstats_allele0 REF \
    --sumstats_n OBS_CT \
    --sumstats_se SE \
    --sumstats_frq A1_FREQ \
    --ld_shrink 0 \
    --n_cores 4 \
    --do_clump_pop1 0 \
    --do_est_beta_pop1 0 \
    --do_predict_pop1 $eur_fit \
    --do_est_beta_pop1_precision $eur_fit \
    --do_est_beta_InformPrior 1 \
    --do_predict_pop2_stage2 1 \
    --do_clump_pop2 0 \
    --do_est_beta_pop2 0 \
    --do_predict_pop2 1 \
    --do_combine 1

