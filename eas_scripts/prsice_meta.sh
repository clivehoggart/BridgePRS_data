#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J CandT[1-26]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 1:00
#BSUB -P acc_psychgen
#BSUB -o CandT.o%J.%I
#BSUB -eo CandT.e%J.%I
#BSUB -M 40000

pheno=( 50     21001 30610 30220 30710 30150  30780 30040 30130 30140  30080 30870 30860)
pheno2=(Height BMI   ALP   Baso  CRP   Eosino LDL-C MCV   Mono  Neutro Plt   TG    TP)

if [ ${LSB_JOBINDEX} -lt 14 ]
then
    pop_ld=EUR
    i=$((${LSB_JOBINDEX}-1))
fi
if [ ${LSB_JOBINDEX} -gt 13 ]
then
    pop_ld=EAS
    i=$((${LSB_JOBINDEX}-14))
fi

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ

cov_names=Age,Sex,@PC[1-40]
if [ ${pheno[$i]} = 30780 ] || [ ${pheno[$i]} = 30610 ] || [ ${pheno[$i]} = 30710 ] || [ ${pheno[$i]} = 30870 ] || [ ${pheno[$i]} = 30860 ]
then
    cov_names=$cov_names,Fasting,Dilution
fi

base=$dir/meta/${pheno2[$i]}_genome.gz
~/prsice/PRSice_linux \
    --target /sc/arion/projects/psychgen/ukb/usr/clive/ukb/imputed/chr# \
    --ld /sc/arion/projects/data-ark/1000G/phase3/PLINK/chr# \
    --ld-keep ~/BridgePRS/data/${pop_ld}_IDs.txt \
    --base $base \
    --thread 4 \
    --beta BETA \
    --binary-target F \
    --out $dir/prsice/${pheno2[$i]}_$pop_ld \
    --pheno /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/${pheno[$i]}/EAS-${pheno[$i]}-test.dat \
    --cov /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/${pheno[$i]}/EAS-${pheno[$i]}-test.dat \
    --keep /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapmap/phenotype/${pheno[$i]}/EAS-all.dat \
    --extract /sc/arion/projects/psychgen/ukb/usr/clive/BBJ/bbj.snplist \
    --print-snp \
    --cov-col $cov_names \
    --pheno-col Phenotype \
    --A1 A1 \
    --A2 AX \
    --snp ID \
    --pvalue P \
    --ultra

