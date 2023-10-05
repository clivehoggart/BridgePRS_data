#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J cs[839-1254]
#BSUB -R "span[hosts=1]"
#BSUB -q premium
#BSUB -W 5:00
#BSUB -P acc_psychgen
#BSUB -o cs.o%J.%I
#BSUB -eo cs.e%J.%I
#BSUB -M 20000

file1='/hpc/users/hoggac01/ukb/cs_index.dat'

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

phenos=(50 21001 30080 30710 30140 30040 30630 30240 30610 30780 30130 30070 30670 30870 30220 30860 30530 30770 30150)

pops=(EUR AFR SAS)
pops2=(eur afr sas)

pheno=${phenos[${index1[1]}]}
chr=${index1[2]}
pop=${pops[${index1[0]}]}
pop2=${pops2[${index1[0]}]}

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype

outdir=$dir/cs/${pop}.$pheno
mkdir $outdir
base=$dir/$pheno/${pop}_csx.dat

if [ $pop != "SAS" ]
then
    n_gwas=`zcat $dir/$pheno/$pop-$pheno.linear.gz | head -2 | tail -1 | awk '{print $8}'`
fi
if [ $pop = "SAS" ]
then
    n_gwas=`zcat $dir/$pheno/$pop.genome.Phenotype.glm.linear.gz | head -2 | tail -1 | awk '{print $8}'`
fi

~/PRScs/PRScs.py \
    --ref_dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/software/PRScsx/ukb/ldblk_ukbb_${pop2} \
    --bim_prefix=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/analysis/quick_ridge/result/chr$chr \
    --sst_file=$base \
    --n_gwas=$n_gwas \
    --chrom=$chr \
    --out_dir=$outdir/out
