file1='/hpc/users/hoggac01/1000G/csx_index_with.dat'

causal_list=(with_causal wo_causal)
phi_list=(1 1e-2 1e-4 1e-6)
pops=(eur eas afr)
pops2=(EUR EAS AFR)
n_gwas=(40000 10000 10000)
size=(80k 20k 20k)

index1=(0 2 2 6 26)

causal=${causal_list[${index1[0]}]}
i=${index1[1]}
phi=${phi_list[${index1[2]}]}
chr=${index1[3]}
pheno=SCORE${index1[4]}_AVG

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen

outdir=$dir/csx50_half_n/$pheno.${pops[$i]}.$causal
mkdir $outdir

echo $index1

base1=$dir/gwas50_half_n/${pops[0]}.$pheno.${size[0]}.$causal.csx.dat
base2=$dir/gwas50_half_n/${pops[$i]}.$pheno.${size[$i]}.$causal.csx.dat
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

