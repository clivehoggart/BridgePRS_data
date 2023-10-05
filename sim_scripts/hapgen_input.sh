#BSUB -L /bin/sh
#BSUB -n 1
#BSUB -J hg_input[1-22]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 12:00
#BSUB -P acc_psychgen
#BSUB -o hg_input.o%J.%I
#BSUB -eo hg_input.o%J.e%J.%I
#BSUB -M 60000

module load bcftools
module load R

chr=${LSB_JOBINDEX}
dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/input

bcftools view --include "(0.01 < INFO/AFR_AF & INFO/AFR_AF < 0.99) | (0.01 < INFO/EUR_AF & INFO/EUR_AF < 0.99) | (0.01 < INFO/EAS_AF & INFO/EAS_AF < 0.99)" /sc/arion/projects/psychgen/resources/1000Genome_phase3_ref_panel/ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz -Oz --threads 1 -o $dir/chr${chr}.vcf.gz

zcat $dir/chr${chr}.vcf.gz | tail -n +255 > $dir/chr${chr}.dat
rm $dir/chr${chr}.vcf.gz
gzip -f $dir/chr${chr}.dat

Rscript --vanilla hapgen_input.R $chr
rm $dir/chr${chr}.dat.gz

sed 's/|/ /g' $dir/chr${chr}_eas.bar > $dir/chr${chr}_eas.hap
sed 's/|/ /g' $dir/chr${chr}_afr.bar > $dir/chr${chr}_afr.hap
sed 's/|/ /g' $dir/chr${chr}_eur.bar > $dir/chr${chr}_eur.hap

rm $dir/chr${chr}_*.bar



