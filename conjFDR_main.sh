## ------------------------------------------------------------------------------------
sigfile=/cFDR/MDD_CT_list
line_count=$(awk 'END{print NR}' "$sigfile")
for i in $(seq 1 $line_count);do
IDP=`cat $sigfile|awk 'NR=='$i' {print $1}'`
disease=`cat $sigfile|awk 'NR=='$i' {print $2}'`
name=$(echo "$disease" | awk -F'_' '{print $1}')
## change config.txt and runme.m (batch)
# 定义新的参数值
new_traitfolder="/cFDR/traitfolder/"
new_traitfile1=$IDP".mat"
new_traitname1=$IDP
new_traitfiles=$disease
new_traitnames=$disease
new_outputdir="/cFDR/results/"$IDP"_"$name
new_reffile=software/pleiofdr/ref9545380_1kgPhase3eur_LDr2p1.mat
new_randprune_n=500
new_stattype="conjfdr"
new_fdrthresh="0.05"
new_exclude="[6 25000000 35000000; 8 7200000 12500000]"
cp -f software/pleiofdr/config_default.txt "/cFDR/config_"$IDP"_"$name"_cjfdr.txt"
cp -f software/pleiofdr/runme.m "/cFDR/runme_"$IDP"_"$name"_cjfdr.m" 
configfile="/cFDR/config_"$IDP"_"$name"_cjfdr.txt"
sed -i "s|reffile=.*|reffile=$new_reffile|g" $configfile
sed -i "s|randprune_n=.*|randprune_n=$new_randprune_n|g" $configfile
# 使用 sed 命令修改参数值
sed -i "s|traitfolder=.*|traitfolder=$new_traitfolder|g" $configfile
sed -i "s|traitfile1=.*|traitfile1=$new_traitfile1|g" $configfile
sed -i "s|traitname1=.*|traitname1=$new_traitname1|g" $configfile
sed -i "s|traitfiles=.*|traitfiles={'${new_traitfiles[@]}'}|g" $configfile
sed -i "s|traitnames=.*|traitnames={'${new_traitnames[@]}'}|g" $configfile
sed -i "s|stattype=.*|stattype=$new_stattype|g" $configfile
sed -i "s|fdrthresh=.*|fdrthresh=$new_fdrthresh|g" $configfile
sed -i "s|exclude_chr_pos=.*|exclude_chr_pos=$new_exclude|g" $configfile
# 使用 sed 命令修改 outputdir 参数
sed -i "s|outputdir=.*|outputdir=$new_outputdir|g" $configfile
newconfig="config_"$IDP"_"$name"_cjfdr.txt"
sed -i "4s|config=.*|config='$newconfig'|g" "/cFDR/runme_"$IDP"_"$name"_cjfdr.m"
mv "/cFDR/runme_"$IDP"_"$name"_cjfdr.m" software/pleiofdr/ -f
mv $configfile software/pleiofdr/ -f
done

sigfile=/cFDR/MDD_CT_list
line_count=$(awk 'END{print NR}' "$sigfile")
for i in $(seq 32 62);do
IDP=`cat $sigfile|awk 'NR=='$i' {print $1}'`
disease=`cat $sigfile|awk 'NR=='$i' {print $2}'`
name=$(echo "$disease" | awk -F'_' '{print $1}')
#if [ ! -e "/cFDR/results/"$IDP"_"$name ]; then
cmd="args=\"addpath(genpath('software/pleiofdr/'));runme_"$IDP"_"$name"_cjfdr\"\n/gpfs/chenglan/share/app/imaging/matlab2016b/bin/matlab -nodesktop -nosplash -r \"\$args\""
echo -e $cmd >"/cFDR/a"$IDP"_"$disease"_cfdr.sh"
#nohup sh "/cFDR/a"$IDP"_"$disease"_cfdr.sh">"/cFDR/a"$IDP"_"$disease"_cfdr.log" 2>&1 &
qsub -q cluster5 -e "/cFDR/a"$IDP"_"$disease"_cfdr.err" -o "/cFDR/a"$IDP"_"$disease"_cfdr.out" "/cFDR/a"$IDP"_"$disease"_cfdr.sh"
#fi
done


sigfile=/cFDR/FA_cFDR_list.txt
line_count=$(awk 'END{print NR}' "$sigfile")
for i in $(seq 1 $line_count);do
IDP=`cat $sigfile|awk 'NR=='$i' {print $1}'`
disease=`cat $sigfile|awk 'NR=='$i' {print $2}'`
name=$(echo "$disease" | awk -F'_' '{print $1}')
#anaconda/anaconda3/envs/ldsc/bin/python2 software/pleiofdr/python_convert/fdrmat2csv.py \
#--mat "/cFDR/results/"$IDP"_"$name"/result.mat" \
#--ref software/pleiofdr/9545380.ref \
#--out "/cFDR/results/"$IDP"_"$name"/result.mat.csv"
anaconda/anaconda3/envs/ldsc/bin/python2 software/pleiofdr/python_convert/sumstats.py clump \
	--clump-field FDR \
	--force  \
	--plink plink \
	--sumstats /cFDR/results/"$IDP"_"$name"/result.mat.csv \
	--bfile-chr software/pleiofdr/chr@ \
	--exclude-ranges '6:25000000-35000000' \
	--clump-p1 0.05 \
	--out /cFDR/results/"$IDP"_"$name"/result_FUMA_leadsnp.csv
done
