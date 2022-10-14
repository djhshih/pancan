library(io)
library(data.table)

# human genome build in PanCanAtlas: hg19

message("Expression")

in.fn <- as.filename("expr_pancan.tsv");
out.fn <- set_fext(in.fn, "rds");

expr0 <- fread(tag(in.fn));

features <- expr0[[1]];
features.ss <- strsplit(features, "|", fixed=TRUE);
genes <- unlist(lapply(features.ss, function(x) x[1]));
genes[genes == "?"] <- NA; 
entrezs <- unlist(lapply(features.ss, function(x) x[2]));

expr <- expr0;
expr[, gene_id:=NULL];
expr <- as.matrix(expr);

sum(duplicated(entrezs))

idx <- duplicated(genes);
print(genes[idx])

valid <- !idx & !is.na(genes);
expr <- expr[valid, ];
genes <- genes[valid];
entrezs <- entrezs[valid];
rownames(expr) <- genes;

min.expr <- min(as.numeric(expr), na.rm=TRUE);

eset <- list(
	features = data.frame(gene = genes, entrez_id = entrezs),
	data = log2(expr - min.expr + 1)
);

min(as.numeric(eset$data), na.rm=TRUE)

qwrite(eset, out.fn);

#rm(list=ls())

# ---

message("Methylation")

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

# ---

in.fn <- as.filename("mir_pancan.csv");
out.fn <- set_fext(in.fn, "rds");

mir <- fread(tag(in.fn));

features <- mir[[1]];
correction <- mir[[2]];
set(mir, , 1:2, NULL);
mir <- as.matrix(mir);
rownames(mir) <- features;

sum(duplicated(features))

mir.annot <- data.frame(
	mirna = features,
	corrected = ifelse(correction == "Corrected", 1, 0)
);

min.mir <- min(as.numeric(mir), na.rm=TRUE);

mir.set <- list(
	features = mir.annot,
	data = log2(mir - min.mir + 1)
);

min(as.numeric(mir.set$data), na.rm=TRUE)

qwrite(mir.set, out.fn);

