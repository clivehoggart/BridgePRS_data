#BSUB -L /bin/sh
#BSUB -n 1
#BSUB -J clump[1-286]
#BSUB -R "span[hosts=1]"
#BSUB -q premium
#BSUB -W 5:00
#BSUB -P acc_psychgen
#BSUB -o clump.o%J.%I
#BSUB -eo clump.e%J.%I
#BSUB -M 20000

module load plink

phenos=("Height" "BMI" "ALP" "Baso" "CRP" "Eosino" "LDL-C" "MCV" "Mono" "Neutro" "Plt" "TG" "TP")
phenos_ukb=(50 21001 30610 30220 30710 30150 30780 30040 30130 30140 30080 30870 30860)

file1='/hpc/users/hoggac01/bbj/cs_index.dat'
i=1
while read line; do
if [ ${LSB_JOBINDEX} = $i ]
then
    index=$line
fi
i=$((i+1))
done < $file1
echo $index

IFS=' '

read -a index1 <<< "$index"

ii=${index1[0]}
chr=${index1[1]}

pheno=${phenos[${ii}]}
pheno_ukb=${phenos_ukb[${ii}]}

qc_snplist=/sc/arion/projects/psychgen/ukb/usr/clive/BBJ/bbj.snplist
sumstats=/sc/arion/projects/psychgen/ukb/usr/clive/BBJ/download/BBJ.${pheno}.autosome.txt.gz

ld_ids=/sc/arion/projects/psychgen/ukb/usr/clive/ukb/eas_ids.txt
bfile=/sc/arion/projects/psychgen/ukb/usr/clive/ukb/imputed/chr
outdir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ/ukb_ld/${pheno_ukb}

#ld_ids=~/BridgePRS/1000G_EAS_ids.txt
#bfile=/sc/arion/projects/data-ark/1000G/phase3/PLINK/chr
#outdir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ/1000G_ld/${pheno_ukb}

mkdir $outdir
mkdir $outdir/clump

rm $outdir/clump/EAS_$chr.clumped.gz
bfile1=$bfile$chr
plink --bfile $bfile1 \
      --chr $chr \
      --clump $sumstats \
      --clump-field P --clump-snp-field SNP \
      --clump-p1 1e-1 --clump-p2 1e-1 --clump-kb 1000 --clump-r2 0.01 \
      --maf 0.005 \
      --keep $ld_ids \
      --extract $qc_snplist \
      --out $outdir/clump/EAS\_$chr
gzip $outdir/clump/EAS_$chr.clumped

