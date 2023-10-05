#!/bin/bash
dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen
pops=(eas afr eur)
nn=(40000 40000 90000)
Ne=(11600 15898 11314)
recomb=(JPT YRI GBR)

for chr in {1..1}
do
for i in {0..2}
do
    pop=${pops[$i]}
    pos=`cat $dir/input/dl${chr}_${pop}.bar`
    ~/hapgen2/hapgen2 -n ${nn[$i]} 0 -Ne ${Ne[$i]} \
		      -l $dir/input/chr${chr}.leg \
		      -m /sc/arion/work/hoggac01/1000G/recomb/${recomb[$i]}-${chr}-final.txt \
		      -dl $pos 0 0 0 \
		      -h $dir/input/chr${chr}_${pop}.hap \
		      -no_haps_output \
		      -o $dir/output/chr${chr}_${pop}
    sed -i "s/id/${pop}/g" $dir/output/chr${chr}_${pop}.controls.sample
    
    ~/plink2 --gen $dir/output/chr${chr}_${pop}.controls.gen ref-last \
	     --sample $dir/output/chr${chr}_${pop}.controls.sample \
	     --oxford-single-chr $chr \
	     --make-pgen \
	     --out $dir/output/chr${chr}_${pop}
    rm $dir/output/chr${chr}_${pop}.cases.*
    rm $dir/output/chr${chr}_${pop}.controls.*

    ~/plink2 --pfile $dir/output/chr${chr}_${pop} \
	     --freq \
	     --out $dir/output/chr${chr}_${pop}
done
done
