#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J meta.res[1-38]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 12:00
#BSUB -P acc_psychgen
#BSUB -o meta.res.o%J.%I
#BSUB -eo meta.res.e%J.%I
#BSUB -M 40000

module load R/4.1.0

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

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/geno/phenotype/
#dir=/sc/arion/projects/psychgen/ukb/usr/clive/ukb/impute_gwas/

for chr in {1..22}
do
    infile1=$dir/${phenos[$i]}/EUR.chr$chr.Phenotype.glm.linear.gz
    infile2=$dir/${phenos[$i]}/$pop.chr$chr.Phenotype.glm.linear.gz
    outfile=$dir/meta/${phenos[$i]}_chr${chr}_${pop}.gz
    Rscript --vanilla ~/1000G/meta.R $infile1 $infile2 $outfile 
done
