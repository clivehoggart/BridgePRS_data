#BSUB -L /bin/sh
#BSUB -n 1
#BSUB -J hg_input[1-20]
#BSUB -R "span[hosts=1]"
#BSUB -q premium
#BSUB -W 12:00
#BSUB -P acc_psychgen
#BSUB -o hg_input.o%J.%I
#BSUB -eo hg_input.o%J.e%J.%I
#BSUB -M 20000
#BSUB -R rusage[mem=200000]

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen
pops=(eas afr eur)
nn=(40000 40000 100000)
Ne=(11600 15898 11314)
recomb=(JPT YRI GBR)
chr=${LSB_JOBINDEX}

for i in {0..2}
do
    pop=${pops[$i]}
    pos=`tail -1 /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/input/chr${chr}.leg | cut -f 2 -d " "`
    pos=`cat $dir/input/dl${chr}_${pop}.bar`
    ~/hapgen2/hapgen2 -n ${nn[$i]} 0 -Ne ${Ne[$i]} \
		      -l $dir/input/chr${chr}.leg \
		      -m /sc/arion/work/hoggac01/1000G/recomb/${recomb[$i]}-${chr}-final.txt \
		      -h $dir/input/chr${chr}_${pop}.hap \
		      -no_haps_output \
                      -dl ${pos} 0 0 0 \
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

