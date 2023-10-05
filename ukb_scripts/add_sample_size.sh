phenos=(50 21001 30080 30710 30140 30040 30630 30240 30610 30780 30130 30070 30670 30870 30220 30860 30530 30770 30150)

pheno_stem=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype
dir=/sc/arion/work/hoggac01/ukb_pheno_results

for i in {0..18}
do
    pheno=${phenos[$i]}
    indir=$dir/$pheno/test5

    echo $pheno_stem/$pheno/EUR-$pheno.linear.gz
    echo $indir/eur_stage1_best_model_params.dat

#Rscript --vanilla ~/ukb/scripts/add_sample_size.R \
#	$pheno_stem/$pheno/EUR-$pheno.linear.gz \
#	$indir/eur_stage1_best_model_params.dat
done
