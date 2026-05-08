library(io)

genes.fname <- "Cosmic_Genes_v101_GRCh38.tsv";

in.fname <- "/data/pancan/rds/expr_pancan.rds";

genes.d <- qread(genes.fname);

idx <- which(genes.d$IN_CANCER_CENSUS == "y");
gene.ids <- sub("\\.\\d+$", "", genes.d$ENTREZ_ID[idx]);

x <- qread(in.fname);

filter_genes <- function(x, genes) {
	idx <- match(genes, x$features$entrez_id);
	message("invalid: ", sum(is.na(idx)))
	idx <- idx[!is.na(idx)];
	x$features <- x$features[idx, ];
	x$data <- x$data[idx, ];
	x
}

x.f <- filter_genes(x, gene.ids);

out.fname <- insert(in.fname, "ccg");
qwrite(x.f, out.fname);

