library(io)

# code	definition	abbreviation
# 10	Blood Derived Normal	NB
# 11	Solid Tissue Normal	NT
# 12	Buccal Cell Normal	NBC
# 13	EBV Immortalized Normal	NEBV
# 14	Bone Marrow Normal	NBM

normal.codes <- c("10", "11", "12", "13", "14");

is_normal <- function(samples) {
	tokens <- strsplit(samples, "-");
	sample.type <- gsub("[A-Z]", "", unlist(lapply(tokens, function(x) x[4])));
	sample.type %in% normal.codes
}

pheno <- qread("../qc_pancan.tsv");
pheno$is_normal <- is_normal(pheno$aliquot_barcode);
pheno <- pheno[pheno$Do_not_use != "True", ];

params <- list(
	list(
		in.fname = "expr-samples.vtr",
		out.fname = filename("expr", "tumour-normal", date=NA)
	),
	list(
		in.fname = "meth-samples.vtr",
		out.fname = filename("meth", "tumour-normal", date=NA)
	)
);

for (p in params) {
	in.fname <- p$in.fname;
	out.fname <- p$out.fname;

	samples <- readLines(in.fname);

	class(samples)

	tokens <- strsplit(samples, "-");

	sample.type <- gsub("[A-Z]", "", unlist(lapply(tokens, function(x) x[4])));
	table(sample.type)

	is.normal <- sample.type %in% normal.codes

	samples[is.normal]
	table(is.normal)


	idx <- match(samples, pheno$aliquot_barcode);
	table(is.na(idx))

	pheno.m <- pheno[idx, ];

	table(pheno.m$"cancer type")
	ct <- table(pheno.m$"cancer type", pheno.m$is_normal);
	ct

	# at least 5 normals
	types.idx <- ct[,2] >= 5;
	types.valid <- rownames(ct)[types.idx];
	length(types.valid)


	# generate comparison groups of tumours vs. normals within each cancer type
	pheno.s <- split(pheno.m, pheno.m[["cancer type"]]);
	pheno.s <- pheno.s[types.valid];

	sets <- lapply(pheno.s,
		function(d) {
			list(
				normals = d$aliquot_barcode[d$is_normal],
				tumours = d$aliquot_barcode[!d$is_normal]
			)
		}
	);

	qwrite(sets, insert(out.fname, ext="rds"));
}

