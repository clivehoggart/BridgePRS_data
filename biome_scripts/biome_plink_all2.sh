#!/bin/sh
#BSUB -n 4
#BSUB -M 20GB
#BSUB -q premium
#BSUB -W 1:00
#BSUB -P acc_psychgen
#BSUB -J plink2[1-22]
#BSUB -R "span[hosts=1]"
#BSUB -o plink.o%J.%I
#BSUB -eo plink.e%J.%I

home=/hpc/users/hoggac01
my_biomedir=/sc/arion/projects/rg_kennye02/hoggac01
biomedir=/sc/private/regen/data/Regeneron/GSA/imputed_tgp_p3_plink/plink2
chr=${LSB_JOBINDEX}

$home/plink2 --pfile $my_biomedir/bfiles/by_chr/all_clean_chr$chr \
	     --update-name $home/biome/switch_id.txt \
	     --make-pgen \
	     --out $my_biomedir/bfiles/by_chr/all_clean2_chr$chr
rm $my_biomedir/bfiles/by_chr/all_clean_chr$chr\.*

$home/plink2 --pfile $my_biomedir/bfiles/by_chr/all_clean2_chr$chr \
	     --rm-dup force-first \
	     --make-pgen \
	     --out $my_biomedir/bfiles/by_chr/all_clean3_chr$chr
rm $my_biomedir/bfiles/by_chr/all_clean2_chr$chr\.*

