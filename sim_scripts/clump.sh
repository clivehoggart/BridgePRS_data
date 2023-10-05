#BSUB -L /bin/sh
#BSUB -n 1
#BSUB -J clump[1-3960]
#BSUB -R "span[hosts=1]"
#BSUB -q premium
#BSUB -W 5:00
#BSUB -P acc_psychgen
#BSUB -o clump.o%J.%I
#BSUB -eo clump.e%J.%I
#BSUB -M 20000

module load plink

file1='/hpc/users/hoggac01/1000G/clump_index.dat'
i=1
while read line; do
if [ ${LSB_JOBINDEX} = $i ]
then
    index=$line
fi
i=$((i+1))
done < $file1
echo $index

IFS=' '

read -a index1 <<< "$index"

causal_list=(with_causal wo_causal)
pops=(eur afr eas)
pops2=(EUR AFR EAS)

causal=${causal_list[${index1[0]}]}
pop=${pops[${index1[1]}]}
pop2=${pops2[${index1[1]}]}
pheno_index=${index1[2]}
pheno=SCORE${index1[2]}_AVG
chr=${index1[3]}

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen

ref_panel=1000G
#ref_panel=ukb

if [ $ref_panel = 1000G ]
then
    ld_ids=~/BridgePRS/data/${pop2}_IDs.txt
    bfile=/sc/arion/projects/data-ark/1000G/phase3/PLINK/chr
    outdir=$dir/Bridge/herit50_half_n/$causal/$pheno
fi
if [ $ref_panel = ukb ]
then
    bfile=/sc/arion/projects/psychgen/ukb/usr/clive/ukb/imputed/chr
    ld_ids=/sc/arion/projects/psychgen/ukb/usr/clive/ukb/${pop}_ids.txt
    outdir=$dir/Bridge/ukb_ref/$causal/$pheno
fi

mkdir $outdir
mkdir $outdir/clump
sumstats=$dir/gwas50_half_n/${pop}_chr${chr}.${pheno}.glm.linear.gz
rm $outdir/clump/${pop}_$chr.clumped.gz
bfile1=$bfile$chr

if [ $causal = "with_causal" ]
then
    plink --bfile $bfile1 \
	  --chr $chr \
	  --clump $sumstats \
	  --clump-field P --clump-snp-field ID \
	  --clump-p1 1e-1 --clump-p2 1e-1 --clump-kb 1000 --clump-r2 0.01 \
	  --keep $ld_ids \
	  --extract ~/1000G/hm_snps.txt \
	  --maf 0.01 \
	  --out $outdir/clump/${pop}_${chr}
fi
if [ $causal = "wo_causal" ]
then
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
fi
gzip $outdir/clump/${pop}_$chr.clumped

