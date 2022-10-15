# Construct multiomic datasets

library(io)

abbrev_sample_id <- function(x) {
	substring(x, 1, 15)
}

out.fn <- filename("expr-meth-mir-cn", path="multiomic", date=NA);

multi <- qread("sets/multiomic.rds");

expr <- qread("expr_pancan.rds");
meth <- qread("meth_pancan_450k.rds");
mir <- qread("mir_pancan.rds");
cn <- qread("abs-cn_pancan.tsv");
cn <- split(cn, cn$Sample);

xs <- list(
	expr = expr,
	meth = meth,
	mir = mir,
	cn = cn
);

#ctype <- "BRCA";
#stype <- "TP";
#group <- paste0(ctype, "_", stype);

for (group in names(multi)) {
	message(group)

	samples.d <- multi[[group]];
	samples.d <- samples.d[names(xs)];

	ys <- list();

	ys$expr <- xs$expr;
	ys$expr$data <- ys$expr$data[, samples.d$expr, drop=FALSE];

	ys$meth <- xs$meth;
	ys$meth$data <- ys$meth$data[, samples.d$meth, drop=FALSE];
	ys$meth$snp  <- ys$meth$snp[,  samples.d$meth, drop=FALSE];

	ys$mir <- xs$mir;
	ys$mir$data <- ys$mir$data[, samples.d$mir, drop=FALSE];


	ys$cn <- xs$cn[ abbrev_sample_id(samples.d$cn) ];

	dim(ys$expr$data)
	dim(ys$meth$data)
	dim(ys$mir$data)
	length(ys$cn)

	qwrite(ys, insert(out.fn, tag=tolower(group), ext="rds"))
}

