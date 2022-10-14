# combined 27k and 450k data
library(IlluminaHumanMethylation27kanno.ilmn12.hg19)
library(IlluminaHumanMethylation450kanno.ilmn12.hg19)

loc.27k <- IlluminaHumanMethylation27kanno.ilmn12.hg19::Locations;
loc.450k <- IlluminaHumanMethylation450kanno.ilmn12.hg19::Locations;

# Problem: the same probe ID on 27k vs. 450k have different positions!
idx.common <- intersect(rownames(loc.27k), rownames(loc.450k));
cbind(loc.27k[idx.common[1:10], ], loc.450k[idx.common[1:10], ])
# same chromosome
mean(loc.27k[idx.common, "chr"] == loc.450k[idx.common, "chr"], na.rm=TRUE)
# different position!
mean(loc.27k[idx.common, "pos"] == loc.450k[idx.common, "pos"], na.rm=TRUE)
