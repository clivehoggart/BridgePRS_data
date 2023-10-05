#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J CandT[1-60]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 12:00
#BSUB -P acc_psychgen
#BSUB -o CandT.o%J.%I
#BSUB -eo CandT.e%J.%I
#BSUB -M 40000

module load R

Rscript --vanilla /hpc/users/hoggac01/1000G/var_explained_cs.R ${LSB_JOBINDEX}
