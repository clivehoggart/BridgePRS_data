#BSUB -L /bin/sh
#BSUB -n 1
#BSUB -J concat[1-30]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 1:00
#BSUB -P acc_psychgen
#BSUB -o concat.o%J.%I
#BSUB -eo concat.e%J.%I
#BSUB -M 20000

i=${LSB_JOBINDEX}

pop=(eas afr eur)

for j in {0..2}
do
    pheno=SCORE${i}_AVG
    indir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/gwas50_half_n
    rm $indir/${pop[$j]}.genome.${pheno}.glm.linear.gz
    zcat $indir/${pop[$j]}_chr1.${pheno}.glm.linear.gz > $indir/${pop[$j]}.genome.${pheno}.glm.linear
    for chr in {2..22}
    do
	zcat $indir/${pop[$j]}_chr${chr}.${pheno}.glm.linear.gz | tail -n +2 >> $indir/${pop[$j]}.genome.${pheno}.glm.linear
    done
    gzip $indir/${pop[$j]}.genome.${pheno}.glm.linear
done

