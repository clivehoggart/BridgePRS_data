dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen
indir=$dir/scores50
outdir=$dir/scores50_half_n

for pheno_index in {1..30}
do
    head -40001 $indir/SCORE${pheno_index}_AVG_eur_train.dat > $outdir/SCORE${pheno_index}_AVG_eur_train.dat
    head -10001 $indir/SCORE${pheno_index}_AVG_afr_train.dat > $outdir/SCORE${pheno_index}_AVG_afr_train.dat
    head -10001 $indir/SCORE${pheno_index}_AVG_eas_train.dat > $outdir/SCORE${pheno_index}_AVG_eas_train.dat
done

