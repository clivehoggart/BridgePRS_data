#!/usr/bin/env nextflow
nextflow.preview.dsl=2
params.version=false
params.help=false
version='0.0.1'

// Do residualization inverse normalize in all samples together
timestamp='2020-09-12'
if(params.version) {
    System.out.println("")
    System.out.println("Generate GWAS for multiple trait across populations - Version: $version ($timestamp)")
    exit 1
}
// default values
params.geno = 0.02
params.seed = 1234
params.kmean = 4
params.hwe = 1e-8
params.maf = 0.01
params.build = "grch37"
params.windSize = 200
params.windStep = 50
params.r2 = 0.2
params.maxSize = 10000
params.sex = "sd"
params.sexSD = 3
params.maleF = 0.8
params.femaleF = 0.2
params.thres = 0.044

params.extreme=1
params.normal=5
params.perm=10000
if(params.help){
    System.out.println("")
    System.out.println("Run mass GWAS - Version: $version ($timestamp)")
    System.out.println("Usage: ")
    System.out.println("    nextflow run mass_gwas.nf [options]")
	System.out.println("Mandatory arguments:")
    System.out.println("    --sqc         Path to the UK biobank SQC file")
    System.out.println("    --rel         Path to the relatedness data file")
    System.out.println("    --prsice      PRSice executable")
    System.out.println("    --geno        Genotype file prefix ")
    System.out.println("    --bgen        Genotype file prefix ")
    System.out.println("    --sample      Sample file for bgen")
    System.out.println("    --info        Info threshold")
    System.out.println("    --ifile       File contain the info score information")
    System.out.println("    --fam         QCed fam file ")
    System.out.println("    --snp         QCed SNP file ")
    System.out.println("    --trait       File contain list of traits to process")
    System.out.println("    --db          UKB Phenotype database")
    System.out.println("    --blood       QCed blood phenotypes")
    System.out.println("    --bloodMap    Mapping blood trait name to field ID")
    System.out.println("    --drop        Samples who withdrawn consent")
    System.out.println("    --cov         Covariate file containing batch and PCs")
    System.out.println("    --showcase    Data showcase, use to select phenotypes")
    System.out.println("Filtering parameters:")
    System.out.println("    --geno        Genotype missingness. Default: ${params.geno}")
    System.out.println("    --kmean       Number of kmean for pca clustering. Default: ${params.kmean}")
    System.out.println("    --maf         MAF filtering for sample filtering. Default: 0.01")
    System.out.println("    --hwe         HWE filtering. Default: ${params.hwe}")
    System.out.println("    --build       Genome build. Can either be grch37 or grch38. ")
    System.out.println("                  Use to define long LD regions. Default: ${params.build}")
    System.out.println("    --windSize    Window size for prunning. Default: ${params.windSize}")
	System.out.println("    --windStep    Step size for prunning. Default: ${params.windStep}")
    System.out.println("    --r2          Threshold for prunning. Default: ${params.r2}")
    System.out.println("    --maxSize     Maxnumber of samples used for prunning. Default: ${params.maxSize}")
    System.out.println("    --sex         sd or fix.")
    System.out.println("                  sd: exclude samples N sd away from mean, as defined by --sexSD")
    System.out.println("                  fix: exclude male > --maleF and female < --femaleF")
    System.out.println("                  Default: ${params.sex}")
    System.out.println("    --sexSD       Sample with Fstat X SD higher (female)/ lower")
    System.out.println("                  (male) from the mean are filtered. Default: ${params.sexSD}")
    System.out.println("    --maleF       F stat threshold for male. Male with F stat lower")
    System.out.println("                  than this number will be removed. Default: ${params.maleF}")
    System.out.println("    --femaleF     F stat threshold for female. Female with F stat higher")
    System.out.println("                  than this number will be removed. Default: ${params.femaleF}")

    System.out.println("    --relThres    Threshold for removing related samples. Default: ${params.thres}")
    System.out.println("Options:")
    System.out.println("    --seed        Seed for random algorithms. Default: ${params.seed}")
    System.out.println("    --help        Display this help messages")
    exit 1
} 

include {   download_greedy_related;
            relatedness_filtering;
            extract_first_degree } from './greedy_related'

include {   extract_sqc;
            first_pass_geno;
            get_populations;
            remove_dropout_and_invalid;
            basic_qc;
            maf_filter;
            generate_high_ld_region;
            prunning;
            calculate_stat_for_sex;
            filter_sex_mismatch;
            finalize_data;
            get_non_uk_origin } from './plink_qc'

include {   extract_quantitative_traits;
            extract_phenotype_from_sql;
            transform_phenotype;
            extract_blood_biochemistry_from_sql;
            transform_blood_biochemistry_phenotype;
            extract_blood_traits;
            split_pop; } from './phenotype_selection'

include {   run_mass_gwas;
            merge_pop_gwas;
            combine_gwas;
            clumping;
            zip_plots;
            modify_gwas;
            merge_lambda;
            merge_meta } from './prs_analysis'

def fileExists = { fn ->
   if (fn.exists())
       return fn;
    else
       error("\n\n-----------------\nFile $fn does not exist\n\n---\n")
}

def gen_file(a, bgen){
    return bgen.replaceAll("#",a.toString())
}
def gen_idx(a, bgen){
    return gen_file(a, bgen)+".bgi"
}

def get_chr(a, bgen){
    if(bgen.contains("#")){
        return a
    }
    else {
        return 0
    }
}
withdrawn=Channel.fromPath("${params.dropout}")
plink=Channel.fromPath("${params.plink}")
traits=Channel.fromPath("${params.trait}")
blood = Channel.fromPath("${params.blood}")
bloodMap = Channel.fromPath("${params.bloodMap}")
sql=Channel.fromPath("${params.db}")
prsice = Channel.fromPath("${params.prsice}")
showcase = Channel.fromPath("${params.showcase}")
genotype = Channel
    .fromFilePairs("${params.bfile}.{bed,bim,fam}",size:3, flat : true){ file -> file.baseName }  
    .ifEmpty { error "No matching plink files" }        
    .map { a -> [fileExists(a[1]), fileExists(a[2]), fileExists(a[3])] } 

workflow{
    // download required files and compile software
    build_workspace()
    // get population
    extract_population(build_workspace.out.cov)
    // perform basic population sensitive filtering 
    plink_qc(
        build_workspace.out.greedy, 
        build_workspace.out.het, 
        build_workspace.out.sex, 
        extract_population.out)
    get_traits(
        plink_qc.out,
        build_workspace.out.cov)
    perform_gwas(plink_qc.out, get_traits.out)
}

workflow perform_gwas{
    take: pop
    take: pheno
    main:
        pop \
            | combine(pheno, by: 0) \
            | combine(genotype) \
            | combine(plink) \
            | run_mass_gwas
        run_mass_gwas.out \
            | combine(pop) \
            | combine(genotype) \
            | combine(prsice) \
            | clumping 
        afr_ld = clumping.out \
            | filter{it[2] == "AFR"} \
            | map{ a -> [a[0],a[1],a[3]]}
        eur_ld = clumping.out \
            | filter{it[2] == "EUR"} \
            | map{ a -> [a[0],a[1],a[3]]}
        run_mass_gwas.out  \
            | combine(afr_ld, by: [0,1]) \
            | combine(eur_ld, by: [0,1]) \
            | modify_gwas
        eur = modify_gwas.out \
            | filter{it[0] == "EUR"} \
            | map{ a -> [a[1],a[2]]}
        afr = modify_gwas.out \
            | filter{it[0] == "AFR"} \
            | map{ a -> [a[1],a[2]]}
        eur \
            | combine(afr, by: 0) \
            | combine(showcase) \
            | combine(bloodMap) \
            | merge_pop_gwas
        zip_plots(merge_pop_gwas.out.plots.collect())
        merge_lambda(merge_pop_gwas.out.lambda.collect())
        merge_meta(merge_pop_gwas.out.meta.collect())
}


workflow get_traits{
    take: pop
    take: cov
    main:
        extract_quantitative_traits(showcase, bloodMap, traits)
        extract_quantitative_traits.out.normal
            .splitCsv(header: true) 
            .map{row -> ["${row.FieldID}", "${row.Coding}"]} \
            | combine(sql) \
            | transpose \
            | extract_phenotype_from_sql
            /*
        extract_phenotype_from_sql.out \
            | combine(withdrawn) \
            | combine(cov) \
            | transform_phenotype_no_pop \
            | combine(pop) \
            | split_pop
        */
        extract_phenotype_from_sql.out \
            | combine(pop) \
            | combine(withdrawn) \
            | combine(cov) \
            | transform_phenotype 
            
        extract_quantitative_traits.out.blood
            .splitCsv(header: true) 
            .map{row -> ["${row.FieldID}", "${row.Coding}"]} \
            | combine(sql) \
            | transpose \
            | extract_blood_biochemistry_from_sql
            
        extract_blood_biochemistry_from_sql.out \
            | combine(pop) \
            | combine(withdrawn) \
            | combine(cov) \
            | transform_blood_biochemistry_phenotype 
            
        bloodMap.splitCsv(header: false) \
            | combine(blood) \
            | combine(withdrawn) \
            | combine(pop) \
            | combine(cov) \
            | combine(traits) \
            | extract_blood_traits
        // 9. Remove outliers (6SD away from mean), then
        
        validID = transform_phenotype.out \
            | mix(transform_blood_biochemistry_phenotype.out) \
            | mix(extract_blood_traits.out) \
            | filter{it[1] == "AFR"} \
            | map{a -> [a[0]]}
        pheno=transform_phenotype.out \
            | mix(transform_blood_biochemistry_phenotype.out) \
            | mix(extract_blood_traits.out) \
            | combine(validID, by: 0) \
            | map{a -> [a[1],a[0],a[2]]}
    emit: 
        pheno
}

workflow extract_population{
    take: covar
    main:
        get_non_uk_origin(sql)
        get_populations(
            get_non_uk_origin.out, 
            covar, 
            params.kmean, 
            params.seed,
            params.out)
        populations = get_populations.out.eur \
            | mix(get_populations.out.afr)
    emit:
        populations
}

workflow build_workspace{
    main:
        download_greedy_related()
        sqc = Channel.fromPath("${params.sqc}")
        extract_sqc(sqc, "${params.out}")
    emit:
        greedy=download_greedy_related.out.greedy
        het = extract_sqc.out.het
        cov = extract_sqc.out.covar 
        sex = extract_sqc.out.sex
}

workflow plink_qc{
    take: greedy
    take: het
    take: sex
    take: population
    main:
        first_pass_geno(    genotype, 
                            params.geno, 
                            params.out)
        remove_dropout_and_invalid( genotype, 
                                    het, 
                                    withdrawn, 
                                    params.out)
        
        population \
            | combine(genotype) \
            | combine(first_pass_geno.out.snp) \
            | combine(remove_dropout_and_invalid.out.removed) \
            | combine(Channel.of("${params.hwe}")) \
            | combine(Channel.of("${params.geno}")) \
            | combine(Channel.of("${params.out}")) \
            | basic_qc
        basic_qc.out.qc \
            | combine(genotype) \
            | combine(Channel.of("${params.maf}")) \
            | combine(Channel.of("${params.out}")) \
            | maf_filter
        maf_filter.out \
            | combine(genotype) \
            | combine(Channel.of("${params.build}")) \
            | combine(Channel.of("${params.out}")) \
            | generate_high_ld_region
        maf_filter.out \
            | combine(generate_high_ld_region.out, by: 0) \
            | combine(genotype) \
            | combine(Channel.of("${params.windSize}")) \
            | combine(Channel.of("${params.windStep}")) \
            | combine(Channel.of("${params.r2}")) \
            | combine(Channel.of("${params.maxSize}")) \
            | combine(Channel.of("${params.seed}")) \
            | combine(Channel.of("${params.out}")) \
            | prunning
        maf_filter.out \
            | combine(prunning.out, by: 0)\
            | combine(genotype) \
            | combine(Channel.of("${params.out}")) \
            | calculate_stat_for_sex
        maf_filter.out \
            | combine(calculate_stat_for_sex.out, by: 0) \
            | combine(sex) \
            | combine(Channel.of("${params.sex}")) \
            | combine(Channel.of("${params.sexSD}")) \
            | combine(Channel.of("${params.maleF}")) \
            | combine(Channel.of("${params.femaleF}")) \
            | combine(Channel.of("${params.out}")) \
            | filter_sex_mismatch
        rel = Channel.fromPath("${params.rel}")    
        filter_sex_mismatch.out.valid \
            | combine(greedy) \
            | combine(rel) \
            | combine(Channel.of("${params.thres}")) \
            | combine(Channel.of("${params.seed}")) \
            | combine(Channel.of("${params.out}")) \
            | relatedness_filtering
        basic_qc.out.qc \
            | combine(filter_sex_mismatch.out.mismatch, by: 0)\
            | combine(relatedness_filtering.out, by:0) \
            | combine(genotype) \
            | combine(Channel.of("${params.out}")) \
            | finalize_data
    emit: 
        finalize_data.out
}



