trait.codes <- c(21001, 30080, 30710, 30140, 30040, 30630, 30240, 30610, 30780, 30130, 30070, 30670, 30870, 30220, 30860, 30530, 30770, 30150, 50 )
traits <- c('BMI','Platelets','CRP','Neutro_count','MCV','apoA1','Retic_count',
                    'ALP','LDL','Mono_count','RDW','Urea','TG','Baso_%','Total_Protein',
            'Urine_sodium','IGDF-1','Eos_count','Height')

for( i in 1:length(traits) ){
    path <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/imputed/test11/"
    infile <- paste0(path,trait.codes[i],'/afr_weighted_combined_snp_weights.dat')
    outfile <- paste0("bridge_models/AFR_",traits[i],".dat")
    cmd <- paste0("cut -d \" \" -f 1-4 ",infile," > tmp.txt")
    system(cmd)
    cmd <- paste0("cat header.txt tmp.txt > ",outfile)
    system(cmd)

    infile <- paste0(path,trait.codes[i],'/SAS_weighted_combined_snp_weights.dat')
    outfile <- paste0("bridge_models/SAS_",traits[i],".dat")
    cmd <- paste0("cut -d \" \" -f 1-4 ",infile," > tmp.txt")
    system(cmd)
    cmd <- paste0("cat header.txt tmp.txt > ",outfile)
    system(cmd)

    path <- "/sc/arion/projects/psychgen/projects/prs/cross_population_prs_development/quick_ridge/results/BBJ/test/"
    infile <- paste0(path,trait.codes[i],'/EAS_weighted_combined_snp_weights.dat')
    outfile <- paste0("bridge_models/EAS_",traits[i],".dat")
    if( file.exists(infile) ){
        cmd <- paste0("cut -d \" \" -f 1-4 ",infile," > tmp.txt")
        system(cmd)
        cmd <- paste0("cat header.txt tmp.txt > ",outfile)
        system(cmd)
    }
}
