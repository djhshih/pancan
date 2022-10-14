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

