ref_panel=ukb
pop=eur

if [ $ref_panel = 1000G ]
then
    ld_ids=~/BridgePRS/data/${pop2}_IDs.txt
    bfile=/sc/arion/projects/data-ark/1000G/phase3/PLINK/chr
    outdir=$dir/Bridge/herit50/$causal/$pheno
    echo "here1"
fi

if [ $ref_panel = ukb ]
then
    ld_ids=/sc/arion/projects/psychgen/ukb/usr/clive/ukb/${pop}_train_ids.txt
    bfile=/sc/arion/projects/psychgen/ukb/usr/clive/ukb/imputed/chr
    outdir=$dir/Bridge/ukb_ref/$causal/$pheno
    echo "here2"
fi

if [ $ref_panel = ukb ] && [ $pop = eur ]
then
    ld_ids=/sc/arion/projects/psychgen/ukb/usr/clive/ukb/ld_ids.txt
    bfile=/sc/arion/projects/psychgen/ukb/usr/clive/ukb/imputed/chr
    outdir=$dir/Bridge/ukb_ref/$causal/$pheno
    echo "here3"
fi

