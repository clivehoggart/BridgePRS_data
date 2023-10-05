#BSUB -L /bin/sh
#BSUB -n 10
#BSUB -J gwas[1-30]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 1:00
#BSUB -P acc_psychgen
#BSUB -o gwas.o%J.%I
#BSUB -eo gwas.o%J.e%J.%I
#BSUB -M 20000

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen
indir=$dir/scores50_half_n
outdir=$dir/gwas50_half_n
pops=(eas afr eur)

pheno_index=${LSB_JOBINDEX}

for i in {0..2}
do
    pop=${pops[$i]}
#    head -5001  $dir/scores/SCORE${pheno_index}_AVG_${pop}_train.dat > \
#	  $dir/scores/SCORE${pheno_index}_AVG_${pop}_train_5k.dat
#    head -10001  $dir/scores/SCORE${pheno_index}_AVG_${pop}_train.dat > \
#	  $dir/scores/SCORE${pheno_index}_AVG_${pop}_train_10k.dat
    for chr in {1..22}
    do
#	~/plink2 --pfile $dir/output/chr${chr}_${pop} \
#		 --glm allow-no-covars omit-ref cols=+a1freq\
#		 --pheno $dir/scores/SCORE${pheno_index}_AVG_${pop}_train_5k.dat \
#		 --pheno-name SCORE${pheno_index}_AVG \
#		 --out $dir/gwas/${pop}_5k_chr${chr}

#	~/plink2 --pfile $dir/output/chr${chr}_${pop} \
#		 --glm allow-no-covars omit-ref cols=+a1freq\
#		 --pheno $dir/scores/SCORE${pheno_index}_AVG_${pop}_train_10k.dat \
#		 --pheno-name SCORE${pheno_index}_AVG \
#		 --out $dir/gwas/${pop}_10k_chr${chr}

	~/plink2 --pfile $dir/output/chr${chr}_${pop} \
		 --glm allow-no-covars omit-ref cols=+a1freq\
		 --pheno $indir/SCORE${pheno_index}_AVG_${pop}_train.dat \
		 --pheno-name SCORE${pheno_index}_AVG \
		 --out $outdir/${pop}_chr${chr}
	gzip -f $outdir/${pop}_chr${chr}.SCORE${pheno_index}_AVG.glm.linear
    done
done

