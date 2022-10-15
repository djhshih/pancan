library(io)

sample_type <- function(samples) {
	tokens <- strsplit(samples, "-");
	gsub("[A-Z].*", "", unlist(lapply(tokens, function(x) x[4])))
}

pheno <- qread("../qc_pancan.tsv");
pheno <- pheno[pheno$Do_not_use != "True", ];

# miRNA samples are duplicated with ".1" append to name:
# remove these duplcates
#pheno %>% filter(aliquot_barcode == "TCGA-E2-A109-01A-11R-A10I-13")
#pheno %>% filter(aliquot_barcode == "TCGA-E2-A109-01A-11R-A10I-13.1")
idx <- grepl("\\.1$", pheno$aliquot_barcode);
pheno <- pheno[!idx, ];

stypes <- sample_type(pheno$aliquot_barcode);
table(stypes)

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
group.d$set <- with(group.d, paste0(cancer_type, "_", sample_type));

with(group.d, table(set))

qwrite(group.d, "annot_sample-type.tsv");

sets <- lapply(split(group.d, group.d$set), function(x) x$sample_id);
#min.set.size <- 5;
#sizes <- vapply(sets, length, 0L);
#sets.f <- sets[sizes >= min.set.size];

qwrite(sets, "sample-type.rds");

# --- Get multiomic sets

library(dplyr)

sample_to_patient <- function(x) {
	unlist(lapply(strsplit(x, "-", fixed=TRUE),
		function(x) paste0(x[1:3], collapse="-")
	))
}


count.d <- group_by(group.d, cancer_type, platform, sample_type) %>%
	summarize(n = n());

platforms <- c(
	expr = "IlluminaHiSeq_RNASeqV2",
	meth = "HumanMethylation450",
	mir = "IlluminaHiSeq_miRNASeq",
	cn = "Genome_Wide_SNP_6"
);

multi.d <- group_by(group.d, patient_id, cancer_type, sample_type) %>%
	summarize(
		n_platforms = length(unique(platform)),
		platforms = paste(unique(platform), collapse=","),
		cn_meth_rna_mir = all(targets %in% platforms)
	);

multi.count.d <- group_by(multi.d, cancer_type, sample_type) %>% 
	filter(cn_meth_rna_mir) %>%
	summarize(n = n()) %>%
	arrange(-n);

get_multiomic <- function(ctype, stype) {
	patients <- multi.d %>% 
		filter(cancer_type == ctype, sample_type == stype, cn_meth_rna_mir) %>% 
		pull(patient_id);

	group.d.f <- filter(group.d, cancer_type == ctype, sample_type == stype);
	group.d.f.s <- split(group.d.f, group.d.f$patient_id);

	multi.sets <- lapply(patients, function(patient) {
		e <- group.d.f.s[[patient]]
		p <- e$sample_id;
		names(p) <- e$platform;
		p[order(names(p))]
	});
	names(multi.sets) <- patients;

	multi.samples <- as.data.frame(lapply(platforms,
		function(platform) {
			unname(unlist(lapply(multi.sets, function(x) x[platform])))
		}
	));

	# check that patient ids match
	multi.patients <- lapply(multi.samples, sample_to_patient)
	stopifnot(with(multi.patients, expr == meth))
	stopifnot(with(multi.patients, expr == mir))
	stopifnot(with(multi.patients, expr == cn))

	multi.samples
}

multis <- with(multi.count.d, mapply(get_multiomic, cancer_type, sample_type, SIMPLIFY=FALSE));
names(multis) <- with(multi.count.d, paste0(cancer_type, "_", sample_type));

qwrite(multi.count.d, "count_multiomic.tsv");

qwrite(multis, "multiomic.rds");

