size=(5k 10k 20k)
causal=(with_causal wo_causal)

dir=/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen

i=0
j=0
pop2=eas
pop_ld=EAS
pheno=1

for i in {0..2}
do
    for j in {0..1}
    do
	base=$dir/meta/eur.$pop2.${size[$i]}.SCORE${pheno}.${causal[$j]}.gz
	~/prsice/PRSice_linux \
	    --target /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/output/chr# \
	    --ld /sc/arion/projects/data-ark/1000G/phase3/PLINK/chr# \
	    --ld-keep ~/BridgePRS/data/${pop_ld}_IDs.txt \
	    --base $base \
	    --thread 4 \
	    --beta BETA \
	    --binary-target F \
	    --out $dir/prsice/$pop_ld.$pop2.${size[$i]}.SCORE${pheno}.${causal[$j]} \
	    --pheno $dir/scores/SCORE${pheno}_AVG_${pop2}_test.dat \
	    --keep $dir/scores/${pop2}_ids.txt \
	    --print-snp \
	    --A1 ALT \
	    --A2 REF \
	    --snp ID \
	    --pvalue P \
	    --ultra \
	    --keep-ambig
    done
done

