#written by menggeliu 2023.10.1
arg = commandArgs(T); info = arg[1]; outdir=arg[2];
library(LAVA)
### Read in data
sum.id<-read.table(info,header=T)
loci = read.loci("/gpfsnew/lab/groupYU/members/liumengge/test/LAVA/MDD2023_FS/shared/shared_loci")
n.loc = nrow(loci)
input = process.input(input.info.file=info,           # input info file
                      sample.overlap.file=NULL,   # sample overlap file (can be set to NULL if there is no overlap)
                      ref.prefix="/gpfs/lab/groupYU/members/liumengge/g1000_eur/g1000_eur",                    # reference genotype data prefix
                      phenos=sum.id$phenotype)       # subset of phenotypes listed in the input info file that we want to process

t1=proc.time()
print(paste("Starting LAVA analysis for",n.loc,"loci"))
for (jj in 1:dim(sum.id)[1]){
### Analyse
u=b=list()
for (i in 1:n.loc){
        locus = process.locus(loci[i,], input)                                          # process locus
        # It is possible that the locus cannot be defined for various reasons (e.g. too few SNPs), so the !is.null(locus) check is necessary before calling the analysis functions.
        if (!is.null(locus) && (sum.id$phenotype[jj]%in%locus$phenos)) {
                loc.info = data.frame(locus = locus$id, chr = locus$chr, start = locus$start, stop = locus$stop, n.snps = locus$n.snps, n.pcs = locus$K)
                # run the univariate tests
                loc.out = run.univ(locus, phenos=sum.id$phenotype[jj])
                u[[i]] = cbind(loc.info, loc.out)
        }
}
# save the output
write.table(do.call(rbind,u), paste0(outdir,"/",sum.id$phenotype[jj],".univ.lava"), row.names=F,quote=F,col.names=T)
}
t2=proc.time()
print(paste("time:",t2[3]-t1[3]))
print(paste0("Done! Analysis output written to ",sum.id$phenotype[jj],".*.lava"))