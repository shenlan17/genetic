sigfile="twas/info"
line_count=$(awk 'END{print NR}' "$sigfile")
gwasfolder=cFDR/traitfolder/
modelfolder=predixcan/elastic_net_models/
for i in $(seq 1 $line_count);do
IDP=`cat $sigfile|awk 'NR=='$i' {print $1}'`
tissue=`cat $sigfile|awk 'NR=='$i' {print $2}'`
predixcan/MetaXcan-master/software/SPrediXcan.py \
--model_db_path $modelfolder"en_Brain_$tissue.db" \
--covariance $modelfolder"en_Brain_$tissue.txt.gz" \
--gwas_folder $gwasfolder \
--gwas_file_pattern "0"$IDP.csv_z.csv.gz \
--snp_column SNP \
--effect_allele_column A1 \
--non_effect_allele_column A2 \
--beta_column BETA \
--pvalue_column PVAL \
--output_file "twas/"$IDP"_"$tissue".csv"
done
