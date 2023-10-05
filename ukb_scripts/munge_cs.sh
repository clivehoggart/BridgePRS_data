#BSUB -L /bin/sh
#BSUB -n 1
#BSUB -J clump[39-57]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 1:00
#BSUB -P acc_psychgen
#BSUB -o clump.o%J.%I
#BSUB -eo clump.e%J.%I
#BSUB -M 20000

if [ ${LSB_JOBINDEX} -lt 20 ]
then
    pop=AFR
    i=${LSB_JOBINDEX}-1
fi
if [ ${LSB_JOBINDEX} -gt 19 ]
then
    pop=EUR
    i=$((${LSB_JOBINDEX}-20))
fi
if [ ${LSB_JOBINDEX} -gt 38 ]
then
    pop=SAS
    i=$((${LSB_JOBINDEX}-39))
fi

phenos=(50 21001 30080 30710 30140 30040 30630 30240 30610 30780 30130 30070 30670 30870 30220 30860 30530 30770 30150)
dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype
pheno=${phenos[$i]}
indir=$dir/$pheno

infile=$indir/$pop-$pheno.linear.gz
if [ $pop = "SAS" ]
then
    infile=$indir/$pop.genome.Phenotype.glm.linear.gz
fi

cp ~/csx_header.dat $indir/${pop}_csx.dat
zcat $infile | tail -n +2 | awk '($9!="NA"){ print $3 "\t" $5 "\t" $4 "\t" $9 "\t" $12}' >> $indir/${pop}_csx.dat
