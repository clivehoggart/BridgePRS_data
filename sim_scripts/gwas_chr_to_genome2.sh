#BSUB -L /bin/sh
#BSUB -n 1
#BSUB -J clump[1-15]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 12:00
#BSUB -P acc_psychgen
#BSUB -o clump.o%J.%I
#BSUB -eo clump.e%J.%I
#BSUB -M 20000

i=${LSB_JOBINDEX}

pop=(eas afr)
size=(5k 10k)

for j in {1..1}
do
    for k in {0..1}
    do
	pheno=SCORE${i}_AVG
	indir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/gwas
	rm $indir/${pop[$j]}.${size[$k]}.genome.${pheno}.glm.linear.gz
	zcat $indir/${pop[$j]}_${size[$k]}_chr1.${pheno}.glm.linear.gz > \
	     $indir/${pop[$j]}.${size[$k]}.genome.${pheno}.glm.linear
	for chr in {2..22}
	do
	    zcat $indir/${pop[$j]}_${size[$k]}_chr${chr}.${pheno}.glm.linear.gz | tail -n +2 >> $indir/${pop[$j]}.${size[$k]}.genome.${pheno}.glm.linear
	done
	gzip $indir/${pop[$j]}.${size[$k]}.genome.${pheno}.glm.linear
    done
done

