#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J CandT[1-60]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 1:00
#BSUB -P acc_psychgen
#BSUB -o CandT.o%J.%I
#BSUB -eo CandT.e%J.%I
#BSUB -M 20000

module load R/4.1.0

if [ ${LSB_JOBINDEX} -lt 31 ]
then
    pop2=afr
    pop_ld=(AFR EUR)
    pheno=${LSB_JOBINDEX}
fi
if [ ${LSB_JOBINDEX} -gt 30 ]
then
    pop2=eas
    pop_ld=(EAS EUR)
    pheno=$((${LSB_JOBINDEX}-30))
fi

size=(20k)
causal=(with_causal wo_causal)

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen
h2=50_half_n
i=0
for k in {0..1}
do
    for j in {0..1}
    do
	base=$dir/meta$h2/eur.$pop2.${size[$i]}.SCORE${pheno}.${causal[$j]}.gz
	~/prsice/PRSice_linux \
	    --target /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/output/chr# \
	    --ld /sc/arion/projects/data-ark/1000G/phase3/PLINK/chr# \
	    --ld-keep ~/BridgePRS/data/${pop_ld[$k]}_IDs.txt \
	    --base $base \
	    --thread 4 \
	    --beta BETA \
	    --binary-target F \
	    --out $dir/prsice$h2/${pop_ld[$k]}.$pop2.${size[$i]}.SCORE${pheno}.${causal[$j]} \
	    --pheno $dir/scores$h2/SCORE${pheno}_AVG_${pop2}_test.dat \
	    --keep $dir/scores/${pop2}_ids.txt \
	    --extract $dir/prsice/${pop_ld[$k]}.$pop2.${size[$i]}.SCORE$pheno.${causal[$j]}.valid \
	    --print-snp \
	    --A1 ALT \
	    --A2 REF \
	    --snp ID \
	    --pvalue P \
	    --ultra \
	    --keep-ambig
    done
done
