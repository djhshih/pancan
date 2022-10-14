library(io)
library(data.table)

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

