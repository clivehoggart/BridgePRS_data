#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J score[1-176]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 1:00
#BSUB -P acc_psychgen
#BSUB -o score.o%J.%I
#BSUB -eo score.e%J.%I
#BSUB -M 20000

file1='/hpc/users/hoggac01/biome/cs_index_bbj.dat'

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

phenos=(Height   BMI   Eosino LDL-C MCV   Mono  Neutro Plt)
phenos2=( 50     21001 30150  30780 30040 30130 30140  30080 30870 30860)

pop=EAS
pop2=eas

pheno=${phenos[${index1[0]}]}
pheno2=${phenos2[${index1[0]}]}
chr=${index1[1]}

my_biomedir=/sc/arion/projects/rg_kennye02/hoggac01
dir_ukb=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype
cs_dir_ukb=$dir_ukb/cs/EUR.$pheno2

dir=/sc/arion/projects/psychgen/ukb/usr/clive/BBJ
cs_dir=$dir/cs/$pheno

#id a1 beta
/hpc/users/hoggac01/plink2 --pfile $my_biomedir/bfiles/by_chr/EAS_csx_clean2_chr$chr \
			   --score $cs_dir/out_pst_eff_a1_b0.5_phiauto_chr$chr.txt 7 4 6 \
			   --list-variants \
			   --out $my_biomedir/preds/by_chr/EAS.EAS_${pheno2}_cs_chr$chr

/hpc/users/hoggac01/plink2 --pfile $my_biomedir/bfiles/by_chr/EAS_csx_clean2_chr$chr \
			   --score $cs_dir_ukb/out_pst_eff_a1_b0.5_phiauto_chr$chr.txt 7 4 6 \
			   --list-variants \
			   --out $my_biomedir/preds/by_chr/EAS.EUR_${pheno2}_cs_chr$chr


