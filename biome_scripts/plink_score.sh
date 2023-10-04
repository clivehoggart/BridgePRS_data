#!/bin/sh
#BSUB -n 1 
#BSUB -M 20GB
#BSUB -q premium
#BSUB -W 48:00
#BSUB -P acc_psychgen
#BSUB -J plink_score[1-19]
#BSUB -R "span[hosts=1]"
#BSUB -o pscore.o%J.%I
#BSUB -eo pscore.e%J.%I

home=/hpc/users/hoggac01
my_biomedir=/sc/arion/projects/rg_kennye02/hoggac01
pop="SAS"
pop2="SAS"
#pheno=(50 21001 30780)
phenos=(00000 50 21001 30080 30710 30140 30040 30630 30240 30610 30780 30130 30070 30670 30870 30220 30860 30530 30770 30150)
panels=( "geno" "hm" "imputed" )
biomedir=/sc/private/regen/data/Regeneron/GSA/imputed_tgp_p3_plink

pheno=${phenos[${LSB_JOBINDEX}]}
panels=( "geno" )

for panel in "${panels[@]}"
do
    if [ ${panel} == "geno" ]
    then
	ukbdir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/geno/test1/${pheno}
	scorefile=${ukbdir}/${pop}_weighted_combined_snp_weights.dat
    fi
    if [ ${panel} == "hm" ]
    then
	ukbdir=/sc/arion/work/hoggac01/ukb_pheno_results/${pheno}/test5
	scorefile=${ukbdir}/${pop2}_weighted_combined_snp_weights.dat
    fi
    if [ ${panel} == "imputed" ]
    then
	ukbdir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/imputed/test11/${pheno}
	scorefile=${ukbdir}/${pop2}_weighted_combined_snp_weights.dat
    fi

    for chr in {1..22}
    do
	$home/plink2 --score $scorefile 5 2 4 list-variants \
		     --pfile $my_biomedir/bfiles/by_chr/${pop}_clean3_chr$chr \
		     --out $my_biomedir/preds/by_chr/${pop}_${pheno}_${panel}_chr$chr
    done
done

#~/plink2   --bfile /sc/arion/projects/rg_kennye02/hoggac01/AFR_score_genos_clean2  --out /sc/arion/projects/rg_kennye02/hoggac01/AFR_21001_geno   --score /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/geno/test1/21001/AFR_weighted_combined_snp_weights.dat 5 2 4
