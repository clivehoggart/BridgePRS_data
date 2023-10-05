#BSUB -L /bin/sh
#BSUB -n 1
#BSUB -J clump[11]
#BSUB -R "span[hosts=1]"
#BSUB -q express
#BSUB -W 12:00
#BSUB -P acc_psychgen
#BSUB -o clump.o%J.%I
#BSUB -eo clump.e%J.%I
#BSUB -M 160000
#BSUB -R rusage[mem=160000]

i=${LSB_JOBINDEX}

pop=(eur afr eas)

    for j in {0..0}
    do
	cut -f 1 -d " " /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/scores/snp_scores$i.dat > /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/scores/causal_snps$i.txt

	zgrep -f /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/scores/causal_snps$i.txt -w  \
	      -v /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/gwas/${pop[$j]}.genome.SCORE${i}_AVG.glm.linear.gz \
	      > /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/gwas/${pop[$j]}.genome.SCORE${i}_AVG.wo_causal
	
	gzip -f /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/gwas/${pop[$j]}.genome.SCORE${i}_AVG.wo_causal

    done
