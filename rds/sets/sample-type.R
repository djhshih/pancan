library(io)

sample_type <- function(samples) {
	tokens <- strsplit(samples, "-");
	gsub("[A-Z].*", "", unlist(lapply(tokens, function(x) x[4])))
}

pheno <- qread("../qc_pancan.tsv");
pheno <- pheno[pheno$Do_not_use != "True", ];

group.fname = filename("sample-type", date=NA);

stypes <- sample_type(pheno$aliquot_barcode);
table(stypes)
pheno$aliquot_barcode[stypes == "20"]

# remove control analyte samples and other unusual sample types
idx <- ! stypes %in% c("20", "40", "50", "60", "61");
pheno <- pheno[idx, ];
stypes <- stypes[idx];

scode <- qread("../../annot/sample-type-code_tcga.tsv", colClasses="character");
# collapse similar groups
scode$letter_code[scode$letter_code == "TAP"] <- "TP";
scode$letter_code[scode$letter_code == "TAM"] <- "TM";
stypesl <- scode$letter_code[match(stypes, scode$code)];


group.d <- pheno[, c("patient_barcode", "aliquot_barcode", "cancer type", "platform")];
colnames(group.d) <- c("patient_id", "sample_id", "cancer_type", "platform");
group.d$sample_type <- stypesl;
group.d$group <- with(group.d, paste0(cancer_type, "_", sample_type));

# convert to factors
group.d$cancer_type <- factor(group.d$cancer_type);
group.d$platform <- factor(group.d$platform);
group.d$sample_type <- factor(group.d$sample_type);
group.d$group <- factor(group.d$group);

with(group.d, table(group))

qwrite(group.d, insert(group.fname, ext="rds"));
