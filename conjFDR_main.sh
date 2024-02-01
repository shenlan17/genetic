# disease data convet to mat
for i in `ls /gpfsnew/lab/groupYU/members/liumengge/test/mixer/data/*.csv.gz`; do
/gpfs/lab/groupYU/members/liumengge/anaconda/anaconda3/envs/ldsc/bin/python2 /gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/python_convert/sumstats.py mat --sumstats $i --ref /gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/9545380.ref --out $i.mat
done
mv -f /gpfsnew/lab/groupYU/members/liumengge/test/mixer/data/*.mat /gpfsnew/lab/groupYU/members/liumengge/test/cFDR/traitfolder/

# IDP data convet to mat
for i in `cat /gpfsnew/lab/groupYU/members/liumengge/test/summaryid_FS`; do
echo $i
awk '{$8=10**(-1*$8)}1' /gpfs/lab/UKBB/UKBB_IDP_GWAS/$i.txt > /gpfsnew/lab/groupYU/members/liumengge/test/cFDR/traitfolder/$i.temp
sed '1c chr rsid pos a1 a2 beta se P' /gpfsnew/lab/groupYU/members/liumengge/test/cFDR/traitfolder/$i.temp > /gpfsnew/lab/groupYU/members/liumengge/test/cFDR/traitfolder/$i.temp1
/gpfs/lab/groupYU/members/liumengge/anaconda/anaconda3/envs/python3.8.8/bin/python3.8 /gpfs/lab/groupYU/members/liumengge/mixer/python_convert-master/sumstats.py csv --sumstats /gpfsnew/lab/groupYU/members/liumengge/test/cFDR/traitfolder/$i.temp1 --out /gpfsnew/lab/groupYU/members/liumengge/test/cFDR/traitfolder/$i.csv --force --auto --head 5 --n-val 33224 --chunksize 1000000
/gpfs/lab/groupYU/members/liumengge/anaconda/anaconda3/envs/python3.8.8/bin/python3.8 /gpfs/lab/groupYU/members/liumengge/mixer/python_convert-master/sumstats.py zscore --sumstats /gpfsnew/lab/groupYU/members/liumengge/test/cFDR/traitfolder/$i.csv --chunksize 1000000 --out /gpfsnew/lab/groupYU/members/liumengge/test/cFDR/traitfolder/$i.csv_z.csv --force 
#/gpfs/lab/groupYU/members/liumengge/anaconda/anaconda3/envs/python3.8.8/bin/python3.8 /gpfs/lab/groupYU/members/liumengge/mixer/python_convert-master/sumstats.py qc --exclude-ranges 6:25000000-35000000 --chunksize 1000000 --out /gpfsnew/lab/groupYU/members/liumengge/test/cFDR/traitfolder/$i.csv_noMHC.csv --force 
/gpfs/lab/groupYU/members/liumengge/anaconda/anaconda3/envs/ldsc/bin/python2 /gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/python_convert/sumstats.py mat \
--sumstats /gpfsnew/lab/groupYU/members/liumengge/test/cFDR/traitfolder/$i.csv_z.csv --ref /gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/9545380.ref \
--out /gpfsnew/lab/groupYU/members/liumengge/test/cFDR/traitfolder/$i.mat --chunksize 1000000
rm -f /gpfsnew/lab/groupYU/members/liumengge/test/cFDR/traitfolder/$i.csv 
rm -f /gpfsnew/lab/groupYU/members/liumengge/test/cFDR/traitfolder/$i.temp1
rm -f /gpfsnew/lab/groupYU/members/liumengge/test/cFDR/traitfolder/$i.temp
done


rm /gpfsnew/lab/groupYU/members/liumengge/test/cFDR/traitfolder/*.temp

## ------------------------------------------------------------------------------------
sigfile=/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/MDD_CT_list
line_count=$(awk 'END{print NR}' "$sigfile")
for i in $(seq 1 $line_count);do
IDP=`cat $sigfile|awk 'NR=='$i' {print $1}'`
disease=`cat $sigfile|awk 'NR=='$i' {print $2}'`
name=$(echo "$disease" | awk -F'_' '{print $1}')
## change config.txt and runme.m (batch)
# 定义新的参数值
new_traitfolder="/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/traitfolder/"
new_traitfile1=$IDP".mat"
new_traitname1=$IDP
new_traitfiles=$disease
new_traitnames=$disease
new_outputdir="/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/results/"$IDP"_"$name
new_reffile=/gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/ref9545380_1kgPhase3eur_LDr2p1.mat
new_randprune_n=500
new_stattype="conjfdr"
new_fdrthresh="0.05"
new_exclude="[6 25119106 33854733; 8 7200000 12500000]"
cp -f /gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/config_default.txt "/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/config_"$IDP"_"$name"_cjfdr.txt"
cp -f /gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/runme.m "/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/runme_"$IDP"_"$name"_cjfdr.m" 
configfile="/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/config_"$IDP"_"$name"_cjfdr.txt"
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
sed -i "4s|config=.*|config='$newconfig'|g" "/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/runme_"$IDP"_"$name"_cjfdr.m"
mv "/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/runme_"$IDP"_"$name"_cjfdr.m" /gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/ -f
mv $configfile /gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/ -f
done

sigfile=/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/MDD_CT_list
line_count=$(awk 'END{print NR}' "$sigfile")
for i in $(seq 32 62);do
IDP=`cat $sigfile|awk 'NR=='$i' {print $1}'`
disease=`cat $sigfile|awk 'NR=='$i' {print $2}'`
name=$(echo "$disease" | awk -F'_' '{print $1}')
#if [ ! -e "/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/results/"$IDP"_"$name ]; then
cmd="args=\"addpath(genpath('/gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/'));runme_"$IDP"_"$name"_cjfdr\"\n/gpfs/chenglan/share/app/imaging/matlab2016b/bin/matlab -nodesktop -nosplash -r \"\$args\""
echo -e $cmd >"/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/a"$IDP"_"$disease"_cfdr.sh"
#nohup sh "/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/a"$IDP"_"$disease"_cfdr.sh">"/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/a"$IDP"_"$disease"_cfdr.log" 2>&1 &
qsub -q cluster5 -e "/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/a"$IDP"_"$disease"_cfdr.err" -o "/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/a"$IDP"_"$disease"_cfdr.out" "/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/a"$IDP"_"$disease"_cfdr.sh"
#fi
done


sigfile=/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/FA_cFDR_list.txt
line_count=$(awk 'END{print NR}' "$sigfile")
for i in $(seq 1 $line_count);do
IDP=`cat $sigfile|awk 'NR=='$i' {print $1}'`
disease=`cat $sigfile|awk 'NR=='$i' {print $2}'`
name=$(echo "$disease" | awk -F'_' '{print $1}')
#/gpfs/lab/groupYU/members/liumengge/anaconda/anaconda3/envs/ldsc/bin/python2 /gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/python_convert/fdrmat2csv.py \
#--mat "/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/results/"$IDP"_"$name"/result.mat" \
#--ref /gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/9545380.ref \
#--out "/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/results/"$IDP"_"$name"/result.mat.csv"
/gpfs/lab/groupYU/members/liumengge/anaconda/anaconda3/envs/ldsc/bin/python2 /gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/python_convert/sumstats.py clump \
	--clump-field FDR \
	--force  \
	--plink plink \
	--sumstats /gpfsnew/lab/groupYU/members/liumengge/test/cFDR/results/"$IDP"_"$name"/result.mat.csv \
	--bfile-chr /gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/chr@ \
	--exclude-ranges '6:25000000-35000000' \
	--clump-p1 0.05 \
	--out /gpfsnew/lab/groupYU/members/liumengge/test/cFDR/results/"$IDP"_"$name"/result_FUMA_leadsnp.csv
done

##整理结果
## -----------------Rscript
rm(list=ls())
dirs <- list.dirs("/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/results/", full.names = F, recursive = FALSE)
new<-matrix(NA,ncol=8,nrow=1)
new1<-matrix(NA,ncol=12,nrow=1)
for (i in 1:length(dirs)){
name<-paste0("/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/results/",dirs[i],"/result_FUMA_leadsnp.csv.loci.csv")
name1<-paste0("/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/results/",dirs[i],"/result_FUMA_leadsnp.csv.snps.csv")
if (file.exists(name)){
data<-read.table(name,header=T)
data1<-read.table(name1,header=T,fill=T)
data<-cbind(dirs[i],data)
data1<-cbind(dirs[i],data1)
colnames(new)<-colnames(data)
colnames(new1)<-colnames(data1)
new<-rbind(new,data)
new1<-rbind(new1,data1)
}
}
new=new[-1,]
new1=new1[-1,]
write.table(new1,"/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/results/MDD2023_FS_conjFDR_candidateSNPs.csv",col.names=T,row.names=F,quote=F)
write.table(new,"/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/results/MDD2023_FS_conjFDR_loci.csv",col.names=T,row.names=F,quote=F)


## -----------------Rscript
rm(list=ls())
complement <- function(x) {
  switch (
    x,
    "A" = "T",
    "C" = "G",
    "T" = "A",
    "G" = "C",
    return(NA)
  )
}
library(data.table)
setwd("/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/traitfolder/")
res<-read.table("/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/results/MDD2023_FS_conjFDR_loci.csv",header=T)
mdd<-fread("/gpfs/lab/groupYU/members/liumengge/GWASsummary/MDD/2023MDD/mdd2023_nodup.txt")
colnames(res)[4]<-"SNP"
all<-as.data.frame(matrix(NA,ncol=14,nrow=1))
for (i in c(195:201,212:218)){
raw<-fread(paste0("0",i,".csv_z.csv.gz"))
new<-merge(res[res[,1]==paste0("0",i,"_MDD2013"),],mdd,by=c("CHR","SNP"))
new<-merge(new,raw,by=c("CHR","SNP"))
new<-new[,c(1:8,10,11,15,17,28:30,32)]
new$`A1.yc`<- sapply(new$`A1.y`, complement)
new$`A2.yc` <- sapply(new$`A2.y`, complement)
ind.re<-which(new$`A1.x`==new$`A2.y` & new$`A2.x`==new$`A1.y` )
ind.cr<-which(new$`A1.x`==new$`A2.yc` & new$`A2.x`==new$`A1.yc` )
new[ind.re,"BETA"]<- -1*new[ind.re,"BETA"]
new[ind.cr,"BETA"]<- -1*new[ind.cr,"BETA"]
new$beta_mdd<-log(new$OR)
new<-new[,c(1:10,19,12,16,13)]
colnames(all)<-colnames(new)
all<-rbind(all,new)
}
all<-all[-1,]
write.table(all,"/gpfsnew/lab/groupYU/members/liumengge/test/cFDR/results/MDD2023_FS_conjFDR_loci_zhengli.csv",col.names=T,quote=F,row.names=F)


