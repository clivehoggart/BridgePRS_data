#!/bin/sh
#BSUB -n 4
#BSUB -M 20GB
#BSUB -q premium
#BSUB -W 48:00
#BSUB -P acc_psychgen
#BSUB -J plink2[1-22]
#BSUB -R "span[hosts=1]"
#BSUB -o plink.o%J.%I
#BSUB -eo plink.e%J.%I

home=/hpc/users/hoggac01
my_biomedir=/sc/arion/projects/rg_kennye02/hoggac01
biomedir=/sc/private/regen/data/Regeneron/GSA/imputed_tgp_p3_plink/plink2
pop='EAS'
chr=${LSB_JOBINDEX}

if [ $chr -gt 9 ]
then
    pfile=$biomedir/GSA_chr$chr
fi
if [ $chr -lt 10 ]
then
    pfile=$biomedir/GSA_chr0$chr
fi

$home/plink2 --pfile $pfile \
	     --maf 0.01 \
	     --extract $home/biome/snplist_info30.dat \
	     --keep $my_biomedir/${pop}_ids2.txt \
	     --make-pgen \
	     --out $my_biomedir/bfiles/by_chr/${pop}_chr$chr

$home/plink2 --pfile $my_biomedir/bfiles/by_chr/${pop}_chr$chr \
	     --rm-dup force-first \
	     --make-pgen \
	     --out $my_biomedir/bfiles/by_chr/${pop}_clean_chr$chr

