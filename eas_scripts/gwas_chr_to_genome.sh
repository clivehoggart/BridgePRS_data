#BSUB -L /bin/sh
#BSUB -n 1
#BSUB -J merge[1-13]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 1:00
#BSUB -P acc_psychgen
#BSUB -o merge.o%J.%I
#BSUB -eo merge.e%J.%I
#BSUB -M 20000

    i=$((${LSB_JOBINDEX}-1))
pheno2=(Height BMI   ALP   Baso  CRP   Eosino LDL-C MCV   Mono  Neutro Plt   TG    TP)

    indir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ/meta
    rm $indir/${pheno2[$i]}_genome*
    zcat $indir/${pheno2[$i]}_chr1.gz > $indir/${pheno2[$i]}_genome
    for chr in {2..22}
    do
	zcat $indir/${pheno2[$i]}_chr${chr}.gz | tail -n +2 >> $indir/${pheno2[$i]}_genome
    done
    gzip $indir/${pheno2[$i]}_genome
