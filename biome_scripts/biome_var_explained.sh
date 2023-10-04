#!/bin/sh
#BSUB -n 4
#BSUB -M 20GB
#BSUB -q premium
#BSUB -W 48:00
#BSUB -P acc_psychgen
#BSUB -J v.exp2[1-1]
#BSUB -R "span[hosts=1]"
#BSUB -o v.exp.o%J.%I
#BSUB -eo v.exp.e%J.%I

home=/hpc/users/hoggac01
my_biomedir=/sc/arion/projects/rg_kennye02/hoggac01
biomedir=/sc/private/regen/data/Regeneron/GSA/imputed_tgp_p3_plink/plink2
pops=( "dummy" "AFR" "SAS" )
pop=${pops[${LSB_JOBINDEX}]}

module load R
#Rscript --vanilla ~/biome/biome_var_explained.R $pop
Rscript --vanilla ~/biome/biome_var_explained_bbj.R
