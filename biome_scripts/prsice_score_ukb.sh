#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J score[1-572]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 1:00
#BSUB -P acc_psychgen
#BSUB -o score.o%J.%I
#BSUB -eo score.e%J.%I
#BSUB -M 20000

file1='/hpc/users/hoggac01/biome/cs_index_ukb.dat'

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

phenos=(50 21001 30070 30220 30710 30150  30780 30040 30130 30140  30080 30870 30860)

pops=(AFR SAS)
pops2=(afr sas)

pheno=${phenos[${index1[1]}]}
chr=${index1[2]}
i=${index1[0]}
pop=${pops[${i}]}
pop2=${pops2[${i}]}

my_biomedir=/sc/arion/projects/rg_kennye02/hoggac01
dir=/sc/arion/projects/psychgen/ukb/usr/clive/ukb/impute_gwas/prsice

/hpc/users/hoggac01/plink2 --pfile $my_biomedir/bfiles/by_chr/${pop}_clean3_chr$chr \
			   --score $dir/${pheno}_${pop}_${pop}.prs 4 6 7 \
			   --out $my_biomedir/preds/by_chr/prsice/${pop}.${pop}_${pheno}_prsice_chr$chr \
			   --list-variants \
			   --threads 4

/hpc/users/hoggac01/plink2 --pfile $my_biomedir/bfiles/by_chr/${pop}_clean3_chr$chr \
			   --score $dir/${pheno}_${pop}_EUR.prs 4 6 7 \
			   --out $my_biomedir/preds/by_chr/prsice/${pop}.EUR_${pheno}_prsice_chr$chr \
			   --list-variants \
			   --threads 4

