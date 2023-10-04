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

phenos=( 50  21001 30780 30040 30080 30130 30140 30150 30070 )
phenos_bbj=(Height BMI LDL-C MCV Plt Mono Neutro Eosino)

pheno=${phenos[${index1[0]}]}
pheno_bbj=${phenos_bbj[${index1[0]}]}
chr=${index1[1]}

my_biomedir=/sc/arion/projects/rg_kennye02/hoggac01
dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ/prsice

/hpc/users/hoggac01/plink2 --pfile $my_biomedir/bfiles/by_chr/EAS_clean3_chr$chr \
			   --score $dir/${pheno_bbj}_EAS.prs 4 6 7 \
			   --out $my_biomedir/preds/by_chr/prsice/EAS.EAS_${pheno}_prsice_chr$chr \
			   --list-variants \
			   --threads 4

/hpc/users/hoggac01/plink2 --pfile $my_biomedir/bfiles/by_chr/EAS_clean3_chr$chr \
			   --score $dir/${pheno_bbj}_EUR.prs 4 6 7 \
			   --out $my_biomedir/preds/by_chr/prsice/EAS.EUR_${pheno}_prsice_chr$chr \
			   --list-variants \
			   --threads 4

