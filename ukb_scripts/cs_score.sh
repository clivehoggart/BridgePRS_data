#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J score[837-1254]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 1:00
#BSUB -P acc_psychgen
#BSUB -o score.o%J.%I
#BSUB -eo score.e%J.%I
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
i=${index1[0]}
pop=${pops[${i}]}
pop2=${pops2[${i}]}

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype
cs_dir=$dir/cs/${pop}.$pheno

bfile=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/analysis/quick_ridge/result

if [ $i -ne 0 ]
then
    /hpc/users/hoggac01/plink2 --bfile $bfile/chr$chr \
			       --score $cs_dir/out_pst_eff_a1_b0.5_phiauto_chr$chr.txt 2 4 6 \
			       --keep /sc/arion/projects/psychgen/ukb/usr/clive/ukb/${pop2}_ids.txt \
			       --out $cs_dir/scores_${pop}_chr$chr
fi

if [ $i -eq 0 ]
then
    /hpc/users/hoggac01/plink2 --bfile $bfile/chr$chr \
			       --score $cs_dir/out_pst_eff_a1_b0.5_phiauto_chr$chr.txt 2 4 6 \
			       --keep /sc/arion/projects/psychgen/ukb/usr/clive/ukb/afr_ids.txt \
			       --out $cs_dir/scores_afr_chr$chr

    /hpc/users/hoggac01/plink2 --bfile $bfile/chr$chr \
			       --score $cs_dir/out_pst_eff_a1_b0.5_phiauto_chr$chr.txt 2 4 6 \
			       --keep /sc/arion/projects/psychgen/ukb/usr/clive/ukb/sas_ids.txt \
			       --out $cs_dir/scores_sas_chr$chr
fi
