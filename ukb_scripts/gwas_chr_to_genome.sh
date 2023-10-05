#BSUB -L /bin/sh
#BSUB -n 1
#BSUB -J clump[20-38]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 12:00
#BSUB -P acc_psychgen
#BSUB -o clump.o%J.%I
#BSUB -eo clump.e%J.%I
#BSUB -M 20000

if [ ${LSB_JOBINDEX} -lt 20 ]
then
    pop=AFR
    i=${LSB_JOBINDEX}-1
fi
if [ ${LSB_JOBINDEX} -gt 19 ]
then
    pop=SAS
    i=$((${LSB_JOBINDEX}-20))
fi

phenos=(50 21001 30080 30710 30140 30040 30630 30240 30610 30780 30130 30070 30670 30870 30220 30860 30530 30770 30150)

dir=(/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/geno/phenotype/ /sc/arion/projects/psychgen/ukb/usr/clive/ukb/impute_gwas/ /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/)

for j in {2..2}
do
    indir=${dir[$j]}/meta
    rm $indir/${phenos[$i]}_genome_${pop}.gz
    zcat $indir/${phenos[$i]}_chr1_${pop}.gz > $indir/${phenos[$i]}_genome_${pop}
    for chr in {2..22}
    do
	zcat $indir/${phenos[$i]}_chr${chr}_${pop}.gz | tail -n +2 >> $indir/${phenos[$i]}_genome_${pop}
    done
    gzip $indir/${phenos[$i]}_genome_${pop}
done
