#eas.SCORE2_AVG.5k.with_causal//scores_eas_chr2.sscore
#afr.SCORE13_AVG.5k.with_causal/scores_afr_chr3.sscore
#eas.SCORE7_AVG.10k.wo_causal/scores_eas_chr2.sscore
#eas.SCORE10_AVG.10k.wo_causal/scores_eas_chr6.sscore

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen

outdir=$dir/cs/eas.SCORE2_AVG.5k.with_causal
mkdir $outdir
base=$dir/gwas/eas.SCORE2_AVG.5k.with_causal.csx.dat
~/PRScs/PRScs.py \
    --ref_dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/software/PRScsx/1000G/ldblk_1kg_eas \
    --bim_prefix=$dir/output/chr2 \
    --sst_file=$base \
    --n_gwas=5000 \
    --chrom=2 \
    --out_dir=$outdir/out
