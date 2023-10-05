#BSUB -L /bin/sh
#BSUB -n 1
#BSUB -J clump[1-30]
#BSUB -q express
#BSUB -W 1:00
#BSUB -P acc_psychgen
#BSUB -o clump.o%J.%I
#BSUB -eo clump.e%J.%I
#BSUB -M 20000
#BSUB -R rusage[mem=20000]

i=${LSB_JOBINDEX}

	cut -f 1 -d " " /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/scores/snp_scores$i.dat > /sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen/scores/causal_snps$i.txt

