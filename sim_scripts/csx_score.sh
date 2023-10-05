#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J score[1-5280]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 1:00
#BSUB -P acc_psychgen
#BSUB -o score.o%J.%I
#BSUB -eo score.e%J.%I
#BSUB -M 20000

file1='/hpc/users/hoggac01/1000G/csx_index_with.dat'

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
phi_list=(1e+00 1e-02 1e-04 1e-06)
pops=(eur eas afr)
pops2=(EUR EAS AFR)
n_gwas=(80000 20000 20000)
size=(80k 20k 20k)

# causal, pop, phi, chr pheno
#if [ ${LSB_JOBINDEX} = 1 ]
#then
#    index1=(1 2 3 18 20)
#fi
#if [ ${LSB_JOBINDEX} = 2 ]
#then
#    index1=(1 2 0 6 16)
#fi
#if [ ${LSB_JOBINDEX} = 3 ]
#then
#    index1=(0 1 3 1 1)
#fi

causal=${causal_list[${index1[0]}]}
i=${index1[1]}
phi=${phi_list[${index1[2]}]}
chr=${index1[3]}
pheno=SCORE${index1[4]}_AVG

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen
cs_dir=$dir/csx50_half_n/$pheno.${pops[$i]}.$causal

/hpc/users/hoggac01/plink2 --bfile $dir/output/chr$chr \
	     --score $cs_dir/out_${pops2[$i]}_pst_eff_a1_b0.5_phi${phi}_chr$chr.txt 2 4 6 \
	     --keep $dir/scores/${pops[$i]}_ids.txt \
	     --out $cs_dir/scores_${pops[$i]}_${phi}_chr$chr

/hpc/users/hoggac01/plink2 --bfile $dir/output/chr$chr \
	     --score $cs_dir/out_EUR_pst_eff_a1_b0.5_phi${phi}_chr$chr.txt 2 4 6 \
	     --keep $dir/scores/${pops[$i]}_ids.txt \
	     --out $cs_dir/scores_eur_${phi}_chr$chr

