# disease data convet to mat
for i in `ls /mixer/data/*.csv.gz`; do
anaconda/anaconda3/envs/ldsc/bin/python2 /gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/python_convert/sumstats.py mat --sumstats $i --ref /gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/9545380.ref --out $i.mat
done
mv -f /mixer/data/*.mat /cFDR/traitfolder/

# IDP data convet to mat
for i in `cat /summaryid_FS`; do
echo $i
awk '{$8=10**(-1*$8)}1' /gpfs/lab/UKBB/UKBB_IDP_GWAS/$i.txt > /cFDR/traitfolder/$i.temp
sed '1c chr rsid pos a1 a2 beta se P' /cFDR/traitfolder/$i.temp > /cFDR/traitfolder/$i.temp1
python3.8 sumstats.py csv --sumstats /cFDR/traitfolder/$i.temp1 --out /cFDR/traitfolder/$i.csv --force --auto --head 5 --n-val 33224 --chunksize 1000000
python3.8 sumstats.py zscore --sumstats /cFDR/traitfolder/$i.csv --chunksize 1000000 --out /cFDR/traitfolder/$i.csv_z.csv --force 
#python3.8 sumstats.py qc --exclude-ranges 6:25000000-35000000 --chunksize 1000000 --out /cFDR/traitfolder/$i.csv_noMHC.csv --force 
anaconda/anaconda3/envs/ldsc/bin/python2 /gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/python_convert/sumstats.py mat \
--sumstats /cFDR/traitfolder/$i.csv_z.csv --ref /gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/9545380.ref \
--out /cFDR/traitfolder/$i.mat --chunksize 1000000
rm -f /cFDR/traitfolder/$i.csv 
rm -f /cFDR/traitfolder/$i.temp1
rm -f /cFDR/traitfolder/$i.temp
done


rm /cFDR/traitfolder/*.temp

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
new_reffile=/gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/ref9545380_1kgPhase3eur_LDr2p1.mat
new_randprune_n=500
new_stattype="conjfdr"
new_fdrthresh="0.05"
new_exclude="[6 25000000 35000000; 8 7200000 12500000]"
cp -f /gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/config_default.txt "/cFDR/config_"$IDP"_"$name"_cjfdr.txt"
cp -f /gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/runme.m "/cFDR/runme_"$IDP"_"$name"_cjfdr.m" 
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
mv "/cFDR/runme_"$IDP"_"$name"_cjfdr.m" /gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/ -f
mv $configfile /gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/ -f
done

sigfile=/cFDR/MDD_CT_list
line_count=$(awk 'END{print NR}' "$sigfile")
for i in $(seq 32 62);do
IDP=`cat $sigfile|awk 'NR=='$i' {print $1}'`
disease=`cat $sigfile|awk 'NR=='$i' {print $2}'`
name=$(echo "$disease" | awk -F'_' '{print $1}')
#if [ ! -e "/cFDR/results/"$IDP"_"$name ]; then
cmd="args=\"addpath(genpath('/gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/'));runme_"$IDP"_"$name"_cjfdr\"\n/gpfs/chenglan/share/app/imaging/matlab2016b/bin/matlab -nodesktop -nosplash -r \"\$args\""
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
#anaconda/anaconda3/envs/ldsc/bin/python2 /gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/python_convert/fdrmat2csv.py \
#--mat "/cFDR/results/"$IDP"_"$name"/result.mat" \
#--ref software/pleiofdr/9545380.ref \
#--out "/cFDR/results/"$IDP"_"$name"/result.mat.csv"
anaconda/anaconda3/envs/ldsc/bin/python2 /gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/python_convert/sumstats.py clump \
	--clump-field FDR \
	--force  \
	--plink plink \
	--sumstats /cFDR/results/"$IDP"_"$name"/result.mat.csv \
	--bfile-chr /gpfsnew/lab/groupYU/members/liumengge/software/pleiofdr/chr@ \
	--exclude-ranges '6:25000000-35000000' \
	--clump-p1 0.05 \
	--out /cFDR/results/"$IDP"_"$name"/result_FUMA_leadsnp.csv
done

##整理结果
## -----------------Rscript
rm(list=ls())
dirs <- list.dirs("/cFDR/results/", full.names = F, recursive = FALSE)
new<-matrix(NA,ncol=8,nrow=1)
new1<-matrix(NA,ncol=12,nrow=1)
for (i in 1:length(dirs)){
name<-paste0("/cFDR/results/",dirs[i],"/result_FUMA_leadsnp.csv.loci.csv")
name1<-paste0("/cFDR/results/",dirs[i],"/result_FUMA_leadsnp.csv.snps.csv")
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
write.table(new1,"/cFDR/results/MDD2023_FS_conjFDR_candidateSNPs.csv",col.names=T,row.names=F,quote=F)
write.table(new,"/cFDR/results/MDD2023_FS_conjFDR_loci.csv",col.names=T,row.names=F,quote=F)


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
setwd("/cFDR/traitfolder/")
res<-read.table("/cFDR/results/MDD2023_FS_conjFDR_loci.csv",header=T)
mdd<-fread("GWASsummary/MDD/2023MDD/mdd2023_nodup.txt")
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
write.table(all,"/cFDR/results/MDD2023_FS_conjFDR_loci_zhengli.csv",col.names=T,quote=F,row.names=F)


