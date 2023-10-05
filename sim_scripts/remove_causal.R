library(data.table)

dir="/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/hapgen"
pop=c('eas','afr','eur')

for( i in 1:30 ){
    to.rm <- fread(paste0(dir,'/scores/snp_scores_eur_',i,'.dat'),header=FALSE)
    for( j in 1:3 ){
        gwas <- fread(paste0(dir,'/gwas50_half_n/',pop[j],'.genome.SCORE',i,'_AVG.glm.linear.gz'))
        gwas <- gwas[-match(to.rm$V1,gwas$ID),]
        fwrite(gwas,paste0(dir,'/gwas50_half_n/',pop[j],'.genome.SCORE',i,'_AVG.wo_causal.gz'),sep='\t')
    }
}

