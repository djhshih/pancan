# Extract data for each group

library(io)

samples.g <- qread("sets/sample-type.rds");

#in.fn <- as.filename("expr_pancan.rds");
#in.fn <- as.filename("meth_pancan_450k.rds");
in.fn <- as.filename("mir_pancan.rds");

out.fn <- filename(in.fn, path="group", date=NA)
out.fn$tag <- setdiff(out.fn$tag, "pancan");

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

# ---

abbrev_sample_id <- function(x) {
	substring(x, 1, 15)
}

in.fn <- as.filename("abs-cn_pancan.tsv");

out.fn <- filename(in.fn, path="group", date=NA, ext="rds");
out.fn$tag <- setdiff(out.fn$tag, "pancan");

x <- qread(in.fn);
xs <- split(x, x$Sample);

for (group in names(samples.g)) {
	message(group)

	samples <- abbrev_sample_id(samples.g[[group]]);

	idx <- which(names(xs) %in% samples);
	if (length(idx) > 0) {
		qwrite(xs[idx], insert(out.fn, tag=tolower(group)))
	}
}

