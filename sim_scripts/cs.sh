#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J CandT[1-3960]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 2:00
#BSUB -P acc_psychgen
#BSUB -o CandT.o%J.%I
#BSUB -eo CandT.e%J.%I
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
n_gwas=(40000 10000 10000)
size=(80k 20k 20k)

causal=${causal_list[${index1[0]}]}
pheno=SCORE${index1[2]}_AVG
chr=${index1[3]}
i=${index1[1]}
j=$i

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen

outdir=$dir/cs50_half_n/${pops[$i]}.$pheno.${size[$j]}.$causal
echo $outdir
mkdir $outdir
base=$dir/gwas50_half_n/${pops[$i]}.$pheno.${size[$j]}.$causal.csx.dat
~/PRScs/PRScs.py \
    --ref_dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/software/PRScsx/1000G/ldblk_1kg_${pops[$i]} \
    --bim_prefix=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/output/chr$chr \
    --sst_file=$base \
    --n_gwas=${n_gwas[$j]} \
    --chrom=$chr \
    --out_dir=$outdir/out

