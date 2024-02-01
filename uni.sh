sigfile="test/mixer/disease.list1"

for trait1 in `cat $sigfile`;do
for i in $(seq 1 20);
do
#if [ ! -f "test/mixer/result/"$trait1".fit.rep"$i".json" ]; then
cmd="python3.8 mixer/mixer-master/precimed/mixer.py fit1 --trait1-file test/cFDR/traitfolder/"$trait1" --out test/mixer/result/"$trait1".fit.rep"$i" --power-curve --qq-plots --extract mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.prune_maf0p05_rand2M_r2p8.rep"$i".snps --bim-file mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim --ld-file mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld --lib mixer/mixer-master/src/build/lib/libbgmg.so"
echo $cmd > "test/mixer/script/a"$trait1"_fit1_"$i".sh"
qsub -q cluster5 -e "test/mixer/script/"$trait1"_fit1_"$i".err" -o "test/mixer/script/"$trait1"_fit1_"$i".out" "test/mixer/script/a"$trait1"_fit1_"$i".sh"
#fi
done
done



sigfile="test/mixer/disease.list1"
for trait1 in `cat $sigfile`;do
for i in $(seq 1 20);
do
#if [ ! -f "test/mixer/result/"$trait1".test.rep"$i".json" ]; then
cmd="python3.8 mixer/mixer-master/precimed/mixer.py test1 --trait1-file test/cFDR/traitfolder/"$trait1" --load-params-file test/mixer/result/"$trait1".fit.rep"$i".json --power-curve --qq-plots --out test/mixer/result/"$trait1".test.rep"$i" --bim-file mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.bim --ld-file mixer/1000G_EUR_Phase3_plink/1000G.EUR.QC.@.run4.ld --lib  mixer/mixer-master/src/build/lib/libbgmg.so"
echo $cmd > "test/mixer/script/a"$trait1"_test1_"$i".sh"
qsub -q cluster5 -e "test/mixer/script/"$trait1"_test1_"$i".err" -o "test/mixer/script/"$trait1"_test1_"$i".out" "test/mixer/script/a"$trait1"_test1_"$i".sh"
#fi
done
done

###
python3.8 mixer/mixer-master/precimed/mixer_figures.py combine --json test/mixer/result/MDD2013_noMHC.csv.gz.fit.rep@.json --out test/mixer/result/MDD2013_noMHC.csv.gz.fit.rep.all
python3.8 mixer/mixer-master/precimed/mixer_figures.py one --json test/mixer/result/MDD2013_noMHC.csv.gz.fit.rep.all.json --out test/mixer/result/MDD2013_noMHC.csv.gz.fit.rep.all --statistic mean std

for i in `cat test/summaryid_subcortical`;do
python3.8 mixer/mixer-master/precimed/mixer_figures.py combine --json test/mixer/result/$i.csv_z.csv.gz.fit.rep@.json --out test/mixer/result/$i.csv_z.csv.gz.fit.rep.all
python3.8 mixer/mixer-master/precimed/mixer_figures.py one --json test/mixer/result/$i.csv_z.csv.gz.fit.rep.all.json --out test/mixer/result/$i.csv_z.csv.fit.rep.all --statistic mean std
done
