#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J score[1-286]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 1:00
#BSUB -P acc_psychgen
#BSUB -o score.o%J.%I
#BSUB -eo score.e%J.%I
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
phenos2=( 50     21001 30610 30220 30710 30150  30780 30040 30130 30140  30080 30870 30860)

pop=EAS
pop2=eas

pheno=${phenos[${index1[0]}]}
pheno2=${phenos2[${index1[0]}]}
chr=${index1[1]}

dir_ukb=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype
cs_dir_ukb=$dir_ukb/cs/EUR.$pheno2

dir=/sc/arion/projects/psychgen/ukb/usr/clive/BBJ
cs_dir=$dir/cs/$pheno

bfile=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/analysis/quick_ridge/result

    /hpc/users/hoggac01/plink2 --bfile $bfile/chr$chr \
			       --score $cs_dir/out_pst_eff_a1_b0.5_phiauto_chr$chr.txt 2 4 6 \
			       --keep /sc/arion/projects/psychgen/ukb/usr/clive/ukb/${pop2}_ids.txt \
			       --out $cs_dir/scores_eas_chr$chr

    /hpc/users/hoggac01/plink2 --bfile $bfile/chr$chr \
			       --score $cs_dir_ukb/out_pst_eff_a1_b0.5_phiauto_chr$chr.txt 2 4 6 \
			       --keep /sc/arion/projects/psychgen/ukb/usr/clive/ukb/eas_ids.txt \
			       --out $cs_dir_ukb/scores_eas_chr$chr

