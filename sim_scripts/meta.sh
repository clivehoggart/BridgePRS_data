#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J meta.res[1-60]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 1:00
#BSUB -P acc_psychgen
#BSUB -o meta.res.o%J.%I
#BSUB -eo meta.res.e%J.%I
#BSUB -M 20000

#chr=$(((i-1) % 22 + 1))
#pheno=$(((i-1)/22 + 1))

module load R/4.1.0

if [ ${LSB_JOBINDEX} -lt 31 ]
then
    pop2=afr
    pheno=${LSB_JOBINDEX}
fi
if [ ${LSB_JOBINDEX} -gt 30 ]
then
    pop2=eas
    pheno=$((${LSB_JOBINDEX}-30))
fi

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/
h2=50_half_n

infile1=$dir/gwas$h2/eur.genome.SCORE${pheno}_AVG.wo_causal.gz
infile2=$dir/gwas$h2/$pop2.genome.SCORE${pheno}_AVG.wo_causal.gz
outfile=$dir/meta$h2/eur.$pop2.20k.SCORE${pheno}.wo_causal.gz
Rscript --vanilla /hpc/users/hoggac01/1000G/meta.R $infile1 $infile2 $outfile 

infile1=$dir/gwas$h2/eur.genome.SCORE${pheno}_AVG.glm.linear.gz
infile2=$dir/gwas$h2/$pop2.genome.SCORE${pheno}_AVG.glm.linear.gz
outfile=$dir/meta$h2/eur.$pop2.20k.SCORE${pheno}.with_causal.gz
Rscript --vanilla /hpc/users/hoggac01/1000G/meta.R $infile1 $infile2 $outfile 

