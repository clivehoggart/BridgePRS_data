pop=(afr eas)

for i in {11..15}
do
    for j in {0..1}
    do
	cut -f 1 -d " " /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/scores/snp_scores$i.dat > /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/scores/causal_snps$i.txt

	zgrep -f /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/scores/causal_snps$i.txt -w  \
	      -v /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/gwas/${pop[$j]}.genome.SCORE${i}_AVG.glm.linear.gz \
	      > /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/gwas/${pop[$j]}.genome.SCORE${i}_AVG.wo_causal
	
	gzip -f /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/gwas/${pop[$j]}.genome.SCORE${i}_AVG.wo_causal

	
	zgrep -f /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/scores/causal_snps$i.txt -w  \
	      -v /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/gwas/${pop[$j]}.10k.genome.SCORE${i}_AVG.glm.linear.gz \
	      > /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/gwas/${pop[$j]}.10k.genome.SCORE${i}_AVG.wo_causal
	
	gzip -f /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/gwas/${pop[$j]}.10k.genome.SCORE${i}_AVG.wo_causal

	
	zgrep -f /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/scores/causal_snps$i.txt -w  \
	      -v /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/gwas/${pop[$j]}.5k.genome.SCORE${i}_AVG.glm.linear.gz \
	      > /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/gwas/${pop[$j]}.5k.genome.SCORE${i}_AVG.wo_causal
	
	gzip -f /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/gwas/${pop[$j]}.5k.genome.SCORE${i}_AVG.wo_causal
    done
done
