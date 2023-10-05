phenos=(50 21001 30080 30710 30140 30040 30630 30240 30610 30780 30130 30070 30670 30870 30220 30860 30530 30770 30150)

for i in {0..18}
do
    pheno=${phenos[$i]}
    dir1=/sc/arion/work/hoggac01/ukb_pheno_results/$pheno/test_imputed
    dir2=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/imputed/test11/$pheno
    mv $dir1/models/eur* $dir2/models
    mv $dir1/models/stage1* $dir2/models
    mv $dir1/models/afr_sweep* $dir2/models
    mv $dir1/models/lambda/* $dir2/models/lambda
done
