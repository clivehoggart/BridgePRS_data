#BSUB -L /bin/sh
#BSUB -n 4
#BSUB -J var_exp[1-120]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 1:00
#BSUB -P acc_psychgen
#BSUB -o var_exp.o%J.%I
#BSUB -eo var_exp.e%J.%I
#BSUB -M 20000

module load R

Rscript --vanilla /hpc/users/hoggac01/1000G/var_explained_cs.R ${LSB_JOBINDEX} 50_half_n

