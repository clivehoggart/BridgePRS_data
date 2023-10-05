#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J getprs[1-26]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 1:00
#BSUB -P acc_psychgen
#BSUB -o getprs.o%J.%I
#BSUB -eo getprs.e%J.%I
#BSUB -M 40000

module load R

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
    i=$((${LSB_JOBINDEX}-16))
fi

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ/

base=$dir/meta/${pheno2[$i]}_genome.gz

Rscript --vanilla ~/bin/prsice_getprs.R \
	--sumstats $base \
	--prsice $dir/prsice/${pheno2[$i]}_$pop_ld \
	--sumstats.snpID ID \
	--sumstats.betaID BETA \
	--sumstats.allele1ID A1 \
	--sumstats.allele0ID AX

