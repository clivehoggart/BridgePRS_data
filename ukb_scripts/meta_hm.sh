#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J meta.res[1-19]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 12:00
#BSUB -P acc_psychgen
#BSUB -o meta.res.o%J.%I
#BSUB -eo meta.res.e%J.%I
#BSUB -M 40000

module load R/4.1.0

i=$((${LSB_JOBINDEX}-1))

phenos=(50 21001 30080 30710 30140 30040 30630 30240 30610 30780 30130 30070 30670 30870 30220 30860 30530 30770 30150)

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype

infile1=$dir/${phenos[$i]}/EUR-$phenos.linear.gz
infile2=$dir/${phenos[$i]}/AFR-$phenos.linear.gz
outfile=$dir/meta/${phenos[$i]}_AFR.gz
Rscript --vanilla ~/1000G/meta.R $infile1 $infile2 $outfile 
