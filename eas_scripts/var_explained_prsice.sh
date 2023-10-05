#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J CandT[1-13]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 1:00
#BSUB -P acc_psychgen
#BSUB -o CandT.o%J.%I
#BSUB -eo CandT.e%J.%I
#BSUB -M 20000

module load R

Rscript --vanilla /hpc/users/hoggac01/bbj/var_explained_prsice.R ${LSB_JOBINDEX}

