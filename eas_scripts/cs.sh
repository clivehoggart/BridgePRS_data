#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J cs[23-44]
#BSUB -R "span[hosts=1]"
#BSUB -q premium
#BSUB -W 5:00
#BSUB -P acc_psychgen
#BSUB -o cs.o%J.%I
#BSUB -eo cs.e%J.%I
#BSUB -M 20000

file1='/hpc/users/hoggac01/bbj/cs_index.dat'

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

phenos=(Height BMI   ALP   Baso  CRP   Eosino LDL-C MCV   Mono  Neutro Plt   TG    TP)

pop2=eas

pheno=${phenos[${index1[0]}]}
chr=${index1[1]}

dir=/sc/arion/projects/psychgen/ukb/usr/clive/BBJ

outdir=$dir/cs/$pheno
mkdir $outdir
base=$dir/$pheno.txt

n_gwas=`head -2 $base | tail -1 | awk '{print $6}'`

echo $n_gwas

~/PRScs/PRScs.py \
    --ref_dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/software/PRScsx/1000G/ldblk_1kg_${pop2} \
    --bim_prefix=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/analysis/quick_ridge/result/chr$chr \
    --sst_file=$base \
    --n_gwas=$n_gwas \
    --chrom=$chr \
    --out_dir=$outdir/out

