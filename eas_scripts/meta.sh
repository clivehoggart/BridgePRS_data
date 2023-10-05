#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J meta.res[1-13]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 1:00
#BSUB -P acc_psychgen
#BSUB -o meta.res.o%J.%I
#BSUB -eo meta.res.e%J.%I
#BSUB -M 40000

module load R/4.1.0

i=$((${LSB_JOBINDEX}-1))

pheno=( 50     21001 30610 30220 30710 30150  30780 30040 30130 30140  30080 30870 30860)
pheno2=(Height BMI   ALP   Baso  CRP   Eosino LDL-C MCV   Mono  Neutro Plt   TG    TP)

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ/

for chr in {1..22}
do
    infile1=/sc/arion/projects/psychgen/ukb/usr/clive/ukb/impute_gwas/${pheno[$i]}/EUR.chr${chr}.Phenotype.glm.linear.gz
    infile2=/sc/arion/projects/psychgen/ukb/usr/clive/BBJ/download/BBJ.${pheno2[$i]}.autosome.txt.gz
    outfile=$dir/meta/${pheno2[$i]}_chr${chr}.gz
    Rscript --vanilla ~/bbj/meta.R $infile1 $infile2 $outfile 
done

