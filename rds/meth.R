library(io)
library(data.table)
library(IlluminaHumanMethylation450kanno.ilmn12.hg19)

# use only 450k samples
# because 27k and 450k platforms have probes with same name but different pos
in.fn <- as.filename("meth_pancan_450k.tsv");
out.fn <- set_fext(in.fn, "rds");

meth <- fread(tag(in.fn));

features <- meth[[1]];
set(meth, , 1L, NULL);
meth <- as.matrix(meth);
rownames(meth) <- features;


idx <- features %in% rownames(Locations);
print(features[!idx])

snp <- meth[!idx, ];
meth <- meth[idx, ];

loc <- Locations[rownames(meth), ];
stopifnot(all(rownames(loc) == rownames(meth)))
annot <- data.frame(
	probe = rownames(meth),
	loc,
	row.names = NULL
);

# TODO Add SNP information
# TODO Add island information
# TODO Add other information

mset <- list(
	features = annot,
	data = meth,
	snp = snp
);

qwrite(mset, out.fn);

