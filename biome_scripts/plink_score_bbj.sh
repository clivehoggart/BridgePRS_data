#!/bin/sh
#BSUB -n 1 
#BSUB -M 20GB
#BSUB -q premium
#BSUB -W 48:00
#BSUB -P acc_psychgen
#BSUB -J plink_score[1-13]
#BSUB -R "span[hosts=1]"
#BSUB -o pscore.o%J.%I
#BSUB -eo pscore.e%J.%I

home=/hpc/users/hoggac01
my_biomedir=/sc/arion/projects/rg_kennye02/hoggac01
pop="EAS"
phenos=(00000 50 21001 30610 30220 30710 30150  30780 30040 30130 30140  30080 30870 30860)
biomedir=/sc/private/regen/data/Regeneron/GSA/imputed_tgp_p3_plink

pheno=${phenos[${LSB_JOBINDEX}]}

bbjdir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ/test/${pheno}
scorefile=${bbjdir}/${pop}_weighted_combined_snp_weights.dat

for chr in {1..22}
do
    $home/plink2 --score $scorefile 5 2 4 list-variants \
		 --pfile $my_biomedir/bfiles/by_chr/${pop}_clean3_chr$chr \
		 --out $my_biomedir/preds/by_chr/${pop}_${pheno}_chr$chr
done

