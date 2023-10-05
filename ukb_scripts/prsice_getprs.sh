#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J CandT[1-38]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 1:00
#BSUB -P acc_psychgen
#BSUB -o CandT.o%J.%I
#BSUB -eo CandT.e%J.%I
#BSUB -M 40000

module load R/4.1.0

phenos=(50 21001 30080 30710 30140 30040 30630 30240 30610 30780 30130 30070 30670 30870 30220 30860 30530 30770 30150)

if [ ${LSB_JOBINDEX} -lt 20 ]
then
    pop=AFR
    i=$((${LSB_JOBINDEX}-1))
fi
if [ ${LSB_JOBINDEX} -gt 19 ]
then
    pop=SAS
    i=$((${LSB_JOBINDEX}-20))
fi

pop_ld=(EUR $pop)

dir=/sc/arion/projects/psychgen/ukb/usr/clive/ukb/impute_gwas/
base=$dir/meta/${phenos[$i]}_genome_$pop.gz

for j in {0..1}
do
    Rscript --vanilla ~/bin/prsice_getprs.R \
	    --sumstats $base \
	    --prsice $dir/prsice/${phenos[$i]}_${pop}_${pop_ld[$j]} \
	    --sumstats.snpID ID \
	    --sumstats.betaID BETA \
	    --sumstats.allele1ID A1 \
	    --sumstats.allele0ID AX
done
