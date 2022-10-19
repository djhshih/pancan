# Extract median within each group

library(io)
library(dplyr)

samples.g0 <- qread("sets/sample-type.rds");
pheno <- qread("sets/count_sample-type.tsv");
pheno <- filter(pheno, platform %in% c("IlluminaHiSeq_RNASeqV2", "IlluminaGA_RNASeqV2")) %>%
	mutate(normal = sample_type %in% c("NT", "NB"));

in.fn <- as.filename("expr_pancan.rds");
out.fn <- filename(in.fn, path="group", date=NA)

x <- qread(in.fn);

min.group.size <- 5;
samples.g <- lapply(samples.g0,
	function(s) {
		samples <- intersect(s, colnames(x$data));
		if (length(samples) >= min.group.size) {
			samples
		} else {
			NULL	
		}
	}
);

samples.g <- samples.g[!unlist(lapply(samples.g, is.null))];

medians <- as.matrix(as.data.frame(lapply(samples.g,
	function(samples) {
		idx <- which(colnames(x$data) %in% samples);
		if (length(idx) > 0) {
			apply(x$data[, idx], 1, median, na.rm=TRUE)
		} else {
			NULL
		}
	}
)));

y <- x;
y$data <- medians;
pheno0 <- data.frame(group = colnames(y$data));
pheno0 <- left_join(pheno0, pheno, by=c(group="set"));
pheno0 <- group_by(pheno0, group, cancer_type, sample_type, normal) %>%
	summarize(n = sum(n)) %>% ungroup() %>% as.data.frame;
stopifnot(colnames(y$data) == pheno0$group);
y$pheno <- pheno0;

qwrite(y, insert(out.fn, "group-median"));

