dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen

outdir=$dir/cs/afr.SCORE13_AVG.5k.with_causal
base=$dir/gwas/afr.SCORE13_AVG.5k.with_causal.csx.dat
~/PRScs/PRScs.py \
    --ref_dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/software/PRScsx/1000G/ldblk_1kg_afr \
    --bim_prefix=$dir/output/chr3 \
    --sst_file=$base \
    --n_gwas=5000 \
    --chrom=3 \
    --out_dir=$outdir/out


outdir=$dir/cs/eas.SCORE7_AVG.10k.wo_causal
base=$dir/gwas/eas.SCORE7_AVG.10k.wo_causal.csx.dat
~/PRScs/PRScs.py \
    --ref_dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/software/PRScsx/1000G/ldblk_1kg_eas \
    --bim_prefix=$dir/output/chr2 \
    --sst_file=$base \
    --n_gwas=10000 \
    --chrom=2 \
    --out_dir=$outdir/out

outdir=$dir/cs/eas.SCORE10_AVG.10k.wo_causal
base=$dir/gwas/eas.SCORE10_AVG.10k.wo_causal.csx.dat
~/PRScs/PRScs.py \
    --ref_dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/software/PRScsx/1000G/ldblk_1kg_eas \
    --bim_prefix=$dir/output/chr6 \
    --sst_file=$base \
    --n_gwas=10000 \
    --chrom=6 \
    --out_dir=$outdir/out

