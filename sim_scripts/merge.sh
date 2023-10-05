#BSUB -L /bin/sh
#BSUB -n 10
#BSUB -J gwas[1-22]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 12:00
#BSUB -P acc_psychgen
#BSUB -o gwas.o%J.%I
#BSUB -eo gwas.o%J.e%J.%I
#BSUB -M 20000

module load plink

chr=${LSB_JOBINDEX}

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/output

#for chr in {1..22}
#do
    plink --bfile $dir/eur_chr$chr --bmerge $dir/afr_chr$chr --allow-no-sex --make-bed --out $dir/tmp$chr
    plink --bfile $dir/tmp$chr --bmerge $dir/eas_chr$chr --allow-no-sex --make-bed --out $dir/chr$chr
#done

