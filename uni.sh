sigfile="/gpfsnew/lab/groupYU/members/liumengge/test/mixer/disease.list1"

for trait1 in `cat $sigfile`;do
for i in $(seq 1 20);
do
#if [ ! -f "/gpfsnew/lab/groupYU/members/liumengge/test/mixer/result/"$trait1".fit.rep"$i".json" ]; then
cmd="/gpfs/lab/groupYU/members/liumengge/anaconda/anaconda3/envs/python3.8.8/bin/python3.8 /gpfs/lab/groupYU/members/liumengge/mixer/mixer-master/precimed/mixer.py fit1 --trait1-file /gpfsnew/lab/groupYU/members/liumengge/test/cFDR/traitfolder/"$trait1" --out /gpfsnew/lab/groupYU/members/liumengge/test/mixer/result/"$trait1".fit.rep"$i" --power-curve --qq-plots --extract /gpfs/lab/groupYU/members/liumengge/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.prune_maf0p05_rand2M_r2p8.rep"$i".snps --bim-file /gpfs/lab/groupYU/members/liumengge/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim --ld-file /gpfs/lab/groupYU/members/liumengge/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld --lib /gpfs/lab/groupYU/members/liumengge/mixer/mixer-master/src/build/lib/libbgmg.so"
echo $cmd > "/gpfsnew/lab/groupYU/members/liumengge/test/mixer/script/a"$trait1"_fit1_"$i".sh"
qsub -q cluster5 -e "/gpfsnew/lab/groupYU/members/liumengge/test/mixer/script/"$trait1"_fit1_"$i".err" -o "/gpfsnew/lab/groupYU/members/liumengge/test/mixer/script/"$trait1"_fit1_"$i".out" "/gpfsnew/lab/groupYU/members/liumengge/test/mixer/script/a"$trait1"_fit1_"$i".sh"
#fi
done
done



sigfile="/gpfsnew/lab/groupYU/members/liumengge/test/mixer/disease.list1"
for trait1 in `cat $sigfile`;do
for i in $(seq 1 20);
do
#if [ ! -f "/gpfsnew/lab/groupYU/members/liumengge/test/mixer/result/"$trait1".test.rep"$i".json" ]; then
cmd="/gpfs/lab/groupYU/members/liumengge/anaconda/anaconda3/envs/python3.8.8/bin/python3.8 /gpfs/lab/groupYU/members/liumengge/mixer/mixer-master/precimed/mixer.py test1 --trait1-file /gpfsnew/lab/groupYU/members/liumengge/test/cFDR/traitfolder/"$trait1" --load-params-file /gpfsnew/lab/groupYU/members/liumengge/test/mixer/result/"$trait1".fit.rep"$i".json --power-curve --qq-plots --out /gpfsnew/lab/groupYU/members/liumengge/test/mixer/result/"$trait1".test.rep"$i" --bim-file /gpfs/lab/groupYU/members/liumengge/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim --ld-file /gpfs/lab/groupYU/members/liumengge/mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld --lib  /gpfs/lab/groupYU/members/liumengge/mixer/mixer-master/src/build/lib/libbgmg.so"
echo $cmd > "/gpfsnew/lab/groupYU/members/liumengge/test/mixer/script/a"$trait1"_test1_"$i".sh"
qsub -q cluster5 -e "/gpfsnew/lab/groupYU/members/liumengge/test/mixer/script/"$trait1"_test1_"$i".err" -o "/gpfsnew/lab/groupYU/members/liumengge/test/mixer/script/"$trait1"_test1_"$i".out" "/gpfsnew/lab/groupYU/members/liumengge/test/mixer/script/a"$trait1"_test1_"$i".sh"
#fi
done
done


###
/gpfs/lab/groupYU/members/liumengge/anaconda/anaconda3/envs/python3.8.8/bin/python3.8 /gpfs/lab/groupYU/members/liumengge/mixer/mixer-master/precimed/mixer_figures.py combine --json /gpfsnew/lab/groupYU/members/liumengge/test/mixer/result/MDD2013_noMHC.csv.gz.fit.rep@.json --out /gpfsnew/lab/groupYU/members/liumengge/test/mixer/result/MDD2013_noMHC.csv.gz.fit.rep.all
/gpfs/lab/groupYU/members/liumengge/anaconda/anaconda3/envs/python3.8.8/bin/python3.8 /gpfs/lab/groupYU/members/liumengge/mixer/mixer-master/precimed/mixer_figures.py one --json /gpfsnew/lab/groupYU/members/liumengge/test/mixer/result/MDD2013_noMHC.csv.gz.fit.rep.all.json --out /gpfsnew/lab/groupYU/members/liumengge/test/mixer/result/MDD2013_noMHC.csv.gz.fit.rep.all --statistic mean std

for i in `cat /gpfsnew/lab/groupYU/members/liumengge/test/summaryid_subcortical`;do
i=0217
/gpfs/lab/groupYU/members/liumengge/anaconda/anaconda3/envs/python3.8.8/bin/python3.8 /gpfs/lab/groupYU/members/liumengge/mixer/mixer-master/precimed/mixer_figures.py combine --json /gpfsnew/lab/groupYU/members/liumengge/test/mixer/result/$i.csv_z.csv.gz.fit.rep@.json --out /gpfsnew/lab/groupYU/members/liumengge/test/mixer/result/$i.csv_z.csv.gz.fit.rep.all
/gpfs/lab/groupYU/members/liumengge/anaconda/anaconda3/envs/python3.8.8/bin/python3.8 /gpfs/lab/groupYU/members/liumengge/mixer/mixer-master/precimed/mixer_figures.py one --json /gpfsnew/lab/groupYU/members/liumengge/test/mixer/result/$i.csv_z.csv.gz.fit.rep.all.json --out /gpfsnew/lab/groupYU/members/liumengge/test/mixer/result/$i.csv_z.csv.fit.rep.all --statistic mean std
done