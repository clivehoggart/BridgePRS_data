#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J Bridge[1-60]
#BSUB -R "span[hosts=1]"
#BSUB -q premium
#BSUB -W 5:00
#BSUB -P acc_psychgen
#BSUB -o Bridge.o%J.%I
#BSUB -eo Bridge.e%J.%I
#BSUB -M 20000

module load R/4.1.0

#chr=${LSB_JOBINDEX}

pop1=eur
pop11=EUR

if [ ${LSB_JOBINDEX} -lt 31 ]
then
    pop2=afr
    pop22=AFR
    i=${LSB_JOBINDEX}
    eur_fit=1
    fst=0.15
fi
if [ ${LSB_JOBINDEX} -gt 30 ]
then
    pop2=eas
    pop22=EAS
    i=$((${LSB_JOBINDEX}-30))
    eur_fit=0
    fst=0.11
fi

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen
pheno=SCORE${i}_AVG

causal=wo_causal

ld_bfile=/sc/arion/projects/data-ark/1000G/phase3/PLINK/chr
pop1_ld_ids=~/BridgePRS/data/${pop11}_IDs.txt
pop2_ld_ids=~/BridgePRS/data/${pop22}_IDs.txt
indir=$dir/Bridge/herit50/$causal/$pheno
outdir=$dir/Bridge/herit50/pv_ranking/$causal/$pheno

~/BridgePRS/bin/BridgePRS2.sh \
    --ranking pv \
    --indir $indir \
    --outdir $outdir \
    --strand_check 1 \
    --pop1 $pop1 \
    --pop2 $pop2 \
    --pop1_sumstats $dir/gwas50/${pop1}_chr \
    --pop2_sumstats $dir/gwas50/${pop2}_chr \
    --by_chr_sumstats .${pheno}.glm.linear.gz \
    --pop1_bfile $dir/output/${pop1}_chr \
    --pop1_ld_bfile $ld_bfile \
    --pop2_bfile $dir/output/${pop2}_chr \
    --pop2_ld_bfile $ld_bfile \
    --pop1_ld_ids $pop1_ld_ids \
    --pop2_ld_ids $pop2_ld_ids \
    --pop1_test_data $dir/scores50/${pheno}_${pop1}_test.dat \
    --pop2_test_data $dir/scores50/${pheno}_${pop2}_test.dat \
    --pop2_valid_data $dir/scores50/${pheno}_${pop2}_valid.dat \
    --fst $fst \
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

