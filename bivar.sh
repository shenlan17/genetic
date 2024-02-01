phe=0218
for i in $(seq 20 20);do
cmd="python3.8 /gpfs/lab/groupYU/members/liumengge/mixer/mixer-master/precimed/mixer.py fit2 --trait1-file /gpfsnew/lab/groupYU/members/liumengge/test/cFDR/traitfolder/"$phe".csv_z.csv.gz --trait2-file /gpfsnew/lab/groupYU/members/liumengge/test/cFDR/traitfolder/MDD2013_noMHC.csv.gz --trait1-params-file /gpfsnew/lab/groupYU/members/liumengge/test/mixer/result/"$phe".csv_z.csv.gz.fit.rep"$i".json --trait2-params-file /gpfsnew/lab/groupYU/members/liumengge/test/mixer/result/MDD2013_noMHC.csv.gz.fit.rep"$i".json --out /gpfsnew/lab/groupYU/members/liumengge/test/mixer/bivar_res/MDD_vs_"$phe".fit.rep"$i" --extract /gpfs/lab/groupYU/members/liumengge/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.prune_maf0p05_rand2M_r2p8.rep"$i".snps --bim-file /gpfs/lab/groupYU/members/liumengge/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim --ld-file /gpfs/lab/groupYU/members/liumengge/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld --lib /gpfs/lab/groupYU/members/liumengge/mixer/mixer-master/src/build/lib/libbgmg.so"
echo $cmd > "/gpfsnew/lab/groupYU/members/liumengge/test/mixer/script/MDD_vs_"$phe"_fit2_"$i".sh"
qsub -q cluster5 -e "/gpfsnew/lab/groupYU/members/liumengge/test/mixer/script/MDD_vs_"$phe"_fit2_"$i".err" -o "/gpfsnew/lab/groupYU/members/liumengge/test/mixer/script/MDD_vs_"$phe"_fit2_"$i".out" "/gpfsnew/lab/groupYU/members/liumengge/test/mixer/script/MDD_vs_"$phe"_fit2_"$i".sh"
done

phe=0217
for i in $(seq 1 5);do
cmd="/gpfs/lab/groupYU/members/liumengge/anaconda/anaconda3/envs/python3.8.8/bin/python3.8 /gpfs/lab/groupYU/members/liumengge/mixer/mixer-master/precimed/mixer.py test2 --trait1-file /gpfsnew/lab/groupYU/members/liumengge/test/cFDR/traitfolder/"$phe".csv_z.csv.gz --trait2-file /gpfsnew/lab/groupYU/members/liumengge/test/cFDR/traitfolder/MDD2013_noMHC.csv.gz --load-params-file /gpfsnew/lab/groupYU/members/liumengge/test/mixer/bivar_res/MDD_vs_"$phe".fit.rep"$i".json --out /gpfsnew/lab/groupYU/members/liumengge/test/mixer/bivar_res/MDD_vs_"$phe".test2.rep"$i" --bim-file /gpfs/lab/groupYU/members/liumengge/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim --ld-file /gpfs/lab/groupYU/members/liumengge/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld --lib  /gpfs/lab/groupYU/members/liumengge/mixer/mixer-master/src/build/lib/libbgmg.so"
echo $cmd > "/gpfsnew/lab/groupYU/members/liumengge/test/mixer/script/MDD_vs_"$phe"_test2_"$i".sh"
qsub -q cluster5 -e "/gpfsnew/lab/groupYU/members/liumengge/test/mixer/script/MDD_vs_"$phe"_test2_"$i".err" -o "/gpfsnew/lab/groupYU/members/liumengge/test/mixer/script/MDD_vs_"$phe"_test2_"$i".out" "/gpfsnew/lab/groupYU/members/liumengge/test/mixer/script/MDD_vs_"$phe"_test2_"$i".sh"
done

###-----------------------results
phe=0218
/gpfs/lab/groupYU/members/liumengge/anaconda/anaconda3/envs/python3.8.8/bin/python3.8 /gpfs/lab/groupYU/members/liumengge/mixer/mixer-master/precimed/mixer_figures.py \
combine --json "/gpfsnew/lab/groupYU/members/liumengge/test/mixer/bivar_res/MDD_vs_"$phe".fit.rep@.json" --out "/gpfsnew/lab/groupYU/members/liumengge/test/mixer/bivar_res/MDD_vs_"$phe".fit"


/gpfs/lab/groupYU/members/liumengge/anaconda/anaconda3/envs/python3.8.8/bin/python3.8 /gpfs/lab/groupYU/members/liumengge/mixer/mixer-master/precimed/mixer_figures.py \
 combine --json /gpfsnew/lab/groupYU/members/liumengge/test/mixer/bivar_res/MDD_vs_"$phe".test2.rep@.json --out /gpfsnew/lab/groupYU/members/liumengge/test/mixer/bivar_res/MDD_vs_"$phe".test2
 
 
/gpfs/lab/groupYU/members/liumengge/anaconda/anaconda3/envs/python3.8.8/bin/python3.8 /gpfs/lab/groupYU/members/liumengge/mixer/mixer-master/precimed/mixer_figures.py \
 two --json-fit /gpfsnew/lab/groupYU/members/liumengge/test/mixer/bivar_res/MDD_vs_"$phe".fit.json --json-test /gpfsnew/lab/groupYU/members/liumengge/test/mixer/bivar_res/MDD_vs_"$phe".test2.json \
 --out /gpfsnew/lab/groupYU/members/liumengge/test/mixer/bivar_res/MDD_vs_"$phe"_bivarres --statistic mean std
