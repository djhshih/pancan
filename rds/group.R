# Extract data for each group

library(io)

samples.g <- qread("sets/sample-type.rds");

#in.fn <- as.filename("expr_pancan.rds");
in.fn <- as.filename("meth_pancan_450k.rds");
#mir <- qread("mir_pancan.rds");
#cn <- qread("abs-cn_pancan.tsv");
#cn <- split(cn, cn$Sample);

out.fn <- filename(in.fn, path="group", date=NA)

x <- qread(in.fn);

for (group in names(samples.g)) {
	message(group)

	samples <- samples.g[[group]];

	y <- x;	
	idx <- which(colnames(y$data) %in% samples);
	if (length(idx) > 0) {
		y$data <- y$data[, idx];
		qwrite(y, insert(out.fn, tag=tolower(group)))
	}
}

