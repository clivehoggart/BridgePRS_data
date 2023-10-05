#BSUB -L /bin/sh
#BSUB -n 1
#BSUB -J hg_input[1-30]
#BSUB -R "span[hosts=1]"
#BSUB -q premium
#BSUB -W 12:00
#BSUB -P acc_psychgen
#BSUB -o hg_input.o%J.%I
#BSUB -eo hg_input.o%J.e%J.%I
#BSUB -M 20000
#BSUB -R rusage[mem=20000]

module load plink

pheno_index=${LSB_JOBINDEX}
pheno=SCORE${pheno_index}_AVG

pops=(eur afr eas)
pops2=(EUR AFR EAS)

bfile=/sc/arion/projects/data-ark/1000G/phase3/PLINK/chr

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen
outdir=$dir/Bridge/herit50/wo_causal/$pheno

mkdir $outdir
mkdir $outdir/clump

for j in {0..2}
do
    for chr in {1..22}
    do
	pop=${pops[$j]}
	pop2=${pops2[$j]}
	ld_ids=~/BridgePRS/data/${pop2}_IDs.txt
	
	sumstats=$dir/gwas50/${pop}_chr${chr}.${pheno}.glm.linear.gz
	rm $outdir/clump/${pop}_$chr.clumped.gz
	bfile1=$bfile$chr
	plink --bfile $bfile1 \
	      --chr $chr \
	      --clump $sumstats \
	      --clump-field P --clump-snp-field ID \
	      --clump-p1 1e-1 --clump-p2 1e-1 --clump-kb 1000 --clump-r2 0.01 \
	      --keep $ld_ids \
	      --extract ~/1000G/hm_snps.txt \
	      --exclude $dir/scores/snp_scores_eur_${pheno_index}.dat \
	      --maf 0.01 \
	      --out $outdir/clump/${pop}_${chr}
	gzip $outdir/clump/${pop}_$chr.clumped
    done
done

