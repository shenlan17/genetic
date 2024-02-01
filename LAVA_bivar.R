#written by menggeliu 2023.10.1
arg = commandArgs(T); info = arg[1]; outdir=arg[2]; sig=arg[3];
library(LAVA)
### Read in data
sum.id<-read.table(info,header=T)
siglist<-read.table(sig,header=F)
loci = read.loci("/gpfsnew/lab/groupYU/members/liumengge/test/LAVA/MDD2023_FS/shared/shared_loci")
input = process.input(input.info.file=info,           # input info file
                      sample.overlap.file=NULL,   # sample overlap file (can be set to NULL if there is no overlap)
                      ref.prefix="/gpfs/lab/groupYU/members/liumengge/g1000_eur/g1000_eur",                    # reference genotype data prefix
                      phenos=sum.id$phenotype)       # subset of phenotypes listed in the input info file that we want to process

t1=proc.time()
b=list()
for (jj in 1:dim(siglist)[1]){
print(paste("Starting LAVA analysis for ",jj,"loci"))
### Analyse
ind<-which(loci[,1]==siglist[jj,3])
        locus = process.locus(loci[ind,], input)    
        phe1<-  strsplit(siglist[jj,2],"\\.")[[1]][1]  
        phe1<-sprintf("%04d", as.numeric(phe1)) 
        phe2<- strsplit(siglist[jj,1],"\\.")[[1]][1]                    
        # It is possible that the locus cannot be defined for various reasons (e.g. too few SNPs), so the !is.null(locus) check is necessary before calling the analysis functions.
        if (!is.null(locus) && phe1%in%locus$phenos && phe2%in%locus$phenos) {
        print("lll")
                loc.info = data.frame(locus = locus$id, chr = locus$chr, start = locus$start, stop = locus$stop, n.snps = locus$n.snps, n.pcs = locus$K)
                # run the univariate tests
                loc.out = run.bivar(locus, phenos=c(phe1,phe2))
                b[[jj]] = cbind(loc.info, loc.out)
        }
}
# save the output
write.table(do.call(rbind,b), paste0(sig,".bivar.res"), row.names=F,quote=F,col.names=T)
t2=proc.time()
print(paste("time:",t2[3]-t1[3]))
print("Done! Analysis output written to bivar.lava")