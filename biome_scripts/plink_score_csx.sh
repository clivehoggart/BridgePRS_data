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

csxdir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/analysis/prscsx/bbj/

pop="EAS"
phenos=(00000 50 21001 30080 30710 30140 30040 30630 30240 30610 30780 30130 30070 30670 30870 30220 30860 30530 30770 30150)
phenos=(00000 50 21001 30610 30220 30710 30150  30780 30040 30130 30140  30080 30870 30860)

stem2=/result/adjusted_effect/${pop}-
scorefile=$csxdir${phenos[$LSB_JOBINDEX]}$stem2${phenos[${LSB_JOBINDEX}]}-best.sumstat

for chr in {1..22}
do
    $home/plink2 --score $scorefile 8 4 6 list-variants \
		 --pfile $my_biomedir/bfiles/by_chr/${pop}_csx_clean2_chr$chr \
		 --out $my_biomedir/preds/by_chr/${pop}_${phenos[${LSB_JOBINDEX}]}_csx_chr$chr
done
