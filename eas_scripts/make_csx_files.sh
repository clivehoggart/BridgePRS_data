pheno2=(Height BMI   ALP   Baso  CRP   Eosino LDL-C MCV   Mono  Neutro Plt   TG    TP)
path=/sc/arion/projects/psychgen/ukb/usr/clive/BBJ
header="SNP A1 A2 BETA P N"

for i in {2..12}
do
    rm $path/${pheno2[$i]}.txt.gz
    echo $header > $path/${pheno2[$i]}.txt
    zgrep -P "^rs" $path/BBJ.${pheno2[$i]}.autosome.txt.gz | awk '{print $1,$5,$4,$13,$10,$12}' | tail -n +2 >> $path/${pheno2[$i]}.txt
gzip $path/${pheno2[$i]}.txt
done

zgrep -P "^rs" $path/BBJ.Height.autosome.txt.gz | awk '{print $13,$5,$4,$16,$12,$14}' > $path/Height.txt
zgrep -P "^rs" $path/BBJ.BMI.autosome.txt.gz | awk '{print $11,$5,$4,$14,$10,$12}' > $path/BMI.txt

