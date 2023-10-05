#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J csx[1-5280]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 12:00
#BSUB -P acc_psychgen
#BSUB -o csx.o%J.%I
#BSUB -eo csx.e%J.%I
#BSUB -M 20000

file1='/hpc/users/hoggac01/1000G/cs_index1.dat'

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
phi_list=(1 1e-2 1e-4 1e-6)
pops=(eur eas afr)
pops2=(EUR EAS AFR)
n_gwas=(80000 20000 20000)
size=(80k 20k 20k)

causal=${causal_list[${index1[0]}]}
i=${index1[1]}
phi=${phi_list[${index1[2]}]}
chr=${index1[3]}
pheno=SCORE${index1[4]}_AVG

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen

outdir=$dir/csx25/$pheno.${pops[$i]}.$causal
mkdir $outdir
base1=$dir/gwas/${pops[0]}.$pheno.${size[0]}.$causal.csx.dat
base2=$dir/gwas/${pops[$i]}.$pheno.${size[$i]}.$causal.csx.dat
~/PRScsx/PRScsx.py \
    --ref_dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/software/PRScsx/1000G \
    --bim_prefix=$dir/output/chr$chr \
    --sst_file=$base1,$base2 \
    --n_gwas=${n_gwas[0]},${n_gwas[$i]} \
    --pop=${pops2[0]},${pops2[$i]} \
    --chrom=$chr \
    --out_dir=$outdir \
    --phi=$phi \
    --out_name=out
