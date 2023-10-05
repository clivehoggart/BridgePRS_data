#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J CandT[1-38]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 12:00
#BSUB -P acc_psychgen
#BSUB -o CandT.o%J.%I
#BSUB -eo CandT.e%J.%I
#BSUB -M 40000

pheno=(50 21001 30080 30710 30140 30040 30630 30240 30610 30780 30130 30070 30670 30870 30220 30860 30530 30770 30150)

if [ ${LSB_JOBINDEX} -lt 20 ]
then
    pop=AFR
    i=${LSB_JOBINDEX}-1
    ld_ids=(/sc/arion/projects/psychgen/ukb/usr/clive/ukb/ld_ids.txt /sc/arion/projects/psychgen/ukb/usr/clive/ukb/afr_train_ids.txt)
fi
if [ ${LSB_JOBINDEX} -gt 19 ]
then
    pop=SAS
    i=$((${LSB_JOBINDEX}-20))
    ld_ids=(/sc/arion/projects/psychgen/ukb/usr/clive/ukb/ld_ids.txt /sc/arion/projects/psychgen/ukb/usr/clive/ukb/sas_train_ids.txt)
fi

pop_ld=(EUR $pop)

dir=/sc/arion/projects/psychgen/ukb/usr/clive/ukb/impute_gwas

cov_names=Age,Sex,@PC[1-40]
type=normal
if [ ${pheno[$i]} = 30780 ] || [ ${pheno[$i]} = 30610 ] || [ ${pheno[$i]} = 30630 ] || [ ${pheno[$i]} = 30710 ] || [ ${pheno[$i]} = 30770 ] || [ ${pheno[$i]} = 30650 ] || [ ${pheno[$i]} = 30810 ] || [ ${pheno[$i]} = 30870 ] || [ ${pheno[$i]} = 30670 ] || [ ${pheno[$i]} = 30750 ] || [ ${pheno[$i]} = 30860 ] || [ ${pheno[$i]} = 30890 ]
then
    cov_names=$cov_names,Fasting,Dilution
    type=bloodbc
fi

base=$dir/meta/${pheno[$i]}_genome_${pop}.gz
for j in {0..1}
do
    ~/prsice/PRSice_linux \
	--target /sc/arion/projects/psychgen/ukb/usr/clive/ukb/imputed/chr# \
	--ld /sc/arion/projects/psychgen/ukb/usr/clive/ukb/imputed/chr# \
	--ld-keep ${ld_ids[$j]} \
	--base $base \
	--thread 4 \
	--beta BETA \
	--binary-target F \
	--out $dir/prsice/${pheno[$i]}_${pop}_${pop_ld[$j]} \
	--pheno /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/${pheno[$i]}/${pheno[$i]}-$pop-$type-trim.target  \
	--cov /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/${pheno[$i]}/${pheno[$i]}-$pop-$type-trim.target  \
	--keep /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/${pheno[$i]}/${pheno[$i]}-$pop-$type.samples \
	--extract /sc/arion/projects/psychgen/ukb/usr/clive/ukb/imputed/chr.$pop.qced.snps.snplist \
	--print-snp \
	--cov-col $cov_names \
	--pheno-col Phenotype \
	--A1 A1 \
	--A2 AX \
	--snp ID \
	--pvalue P \
	--ultra
done
