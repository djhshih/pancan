library(io)
library(data.table)

# combined 27k and 450k data
#library(IlluminaHumanMethylation27kanno.ilmn12.hg19)
#library(IlluminaHumanMethylation450kanno.ilmn12.hg19)

in.fn <- as.filename("meth_pancan.tsv");
out.fn <- set_fext(in.fn, "rds");

meth <- fread(tag(in.fn));

features <- meth[[1]];
set(meth, , 1, NULL);
meth <- as.matrix(meth);
rownames(meth) <- features;

mset <- list(
	features = data.frame(probe = features),
	data = meth
);

qwrite(mset, out.fn);

#rm(list=ls())


