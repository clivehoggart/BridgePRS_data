#BSUB -L /bin/sh
#BSUB -n 1
#BSUB -J munge[1-30]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 1:00
#BSUB -P acc_psychgen
#BSUB -o munge.o%J.%I
#BSUB -eo munge.e%J.%I
#BSUB -M 20000

i=${LSB_JOBINDEX}
pop=(eas afr eur)
indir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/gwas50_half_n
pheno=SCORE${i}_AVG

for j in {0..1}
do
    cp $indir/csx_header.dat $indir/${pop[$j]}.${pheno}.20k.with_causal.csx.dat
    zcat $indir/${pop[$j]}.genome.${pheno}.glm.linear.gz | tail -n +2 | awk '($14!="CONST_OMITTED_ALLELE"){ print $3 "\t" $5 "\t" $4 "\t" $10 "\t" $13}' >> $indir/${pop[$j]}.${pheno}.20k.with_causal.csx.dat
	
    cp $indir/csx_header.dat $indir/${pop[$j]}.${pheno}.20k.wo_causal.csx.dat
    zcat $indir/${pop[$j]}.genome.${pheno}.wo_causal.gz | tail -n +2 | awk '($10!="CONST_OMITTED_ALLELE"){ print $3 "\t" $5 "\t" $4 "\t" $10 "\t" $13}' >> $indir/${pop[$j]}.${pheno}.20k.wo_causal.csx.dat
done

j=2
cp $indir/csx_header.dat $indir/${pop[$j]}.${pheno}.80k.with_causal.csx.dat
zcat $indir/${pop[$j]}.genome.${pheno}.glm.linear.gz | tail -n +2 | awk '($14!="CONST_OMITTED_ALLELE"){ print $3 "\t" $5 "\t" $4 "\t" $10 "\t" $13}' >> $indir/${pop[$j]}.${pheno}.80k.with_causal.csx.dat

cp $indir/csx_header.dat $indir/${pop[$j]}.${pheno}.80k.wo_causal.csx.dat
zcat $indir/${pop[$j]}.genome.${pheno}.wo_causal.gz | tail -n +2 | awk '($10!="CONST_OMITTED_ALLELE"){ print $3 "\t" $5 "\t" $4 "\t" $10 "\t" $13}' >> $indir/${pop[$j]}.${pheno}.80k.wo_causal.csx.dat

