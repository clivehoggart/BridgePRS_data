#BSUB -L /bin/sh
#BSUB -n 1
#BSUB -J hg_input[1-22]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 12:00
#BSUB -P acc_psychgen
#BSUB -o hg_input.o%J.%I
#BSUB -eo hg_input.o%J.e%J.%I
#BSUB -M 20000

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen
pops=(eas afr eur)

chr=${LSB_JOBINDEX}

for pheno_index in {1..30}
do
    for i in {0..2}
    do
	pop=${pops[$i]}
	~/plink2 --pfile $dir/output/chr${chr}_${pop} \
		 --score $dir/scores/snp_scores_${pop}_${pheno_index}.dat list-variants \
		 --out  $dir/scores/chr${chr}_${pop}_scores${pheno_index}
    done
done

