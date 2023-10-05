#BSUB -L /bin/sh
#BSUB -n 10
#BSUB -J bed[1-22]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 12:00
#BSUB -P acc_psychgen
#BSUB -o bed.o%J.%I
#BSUB -eo bed.o%J.e%J.%I
#BSUB -M 20000

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen
pops=(eas afr eur)

chr=${LSB_JOBINDEX}

for i in {0..2}
do
    pop=${pops[$i]}
    ~/plink2 --pfile $dir/output/chr${chr}_${pop} \
	     --keep $dir/output/test_valid.ids \
	     --make-bed \
	     --out $dir/output/${pop}_chr${chr}
done

