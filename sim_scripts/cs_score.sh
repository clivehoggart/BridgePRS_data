#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J score[1-3960]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 1:00
#BSUB -P acc_psychgen
#BSUB -o score.o%J.%I
#BSUB -eo score.e%J.%I
#BSUB -M 20000

file1='/hpc/users/hoggac01/1000G/cs_index.dat'

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
pops=(eur eas afr)
size=(80k 20k 20k)

causal=${causal_list[${index1[0]}]}
pheno=SCORE${index1[2]}_AVG
i=${index1[1]}
chr=${index1[3]}

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen
cs_dir=$dir/cs50_half_n/${pops[$i]}.$pheno.${size[$i]}.$causal

if [ $i = 1 ] || [ $i = 2 ]
then
    /hpc/users/hoggac01/plink2 --bfile $dir/output/chr$chr \
		 --score $cs_dir/out_pst_eff_a1_b0.5_phiauto_chr$chr.txt 2 4 6 \
		 --keep $dir/scores/${pops[$i]}_ids.txt \
		 --out $cs_dir/scores_${pops[$i]}_chr$chr
fi

if [ $i = 0 ]
then
    /hpc/users/hoggac01/plink2 --bfile $dir/output/chr$chr \
      --score $cs_dir/out_pst_eff_a1_b0.5_phiauto_chr$chr.txt 2 4 6 \
      --keep $dir/scores/eas_ids.txt \
      --out $cs_dir/scores_eas_chr$chr

    /hpc/users/hoggac01/plink2 --bfile $dir/output/chr$chr \
      --score $cs_dir/out_pst_eff_a1_b0.5_phiauto_chr$chr.txt 2 4 6 \
      --keep $dir/scores/afr_ids.txt \
      --out $cs_dir/scores_afr_chr$chr
fi

