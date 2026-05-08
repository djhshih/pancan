# TCGA PanCanAtlas Multi-Omic Data Pipeline

Processes raw TCGA PanCanAtlas data from the NCI Genomic Data Commons (GDC) into analysis-ready R datasets covering 30+ cancer types.

## Data Modalities

| Modality | Raw File | Processed Output |
|----------|----------|-----------------|
| Gene expression (RNA-seq) | `EBPlusPlusAdjustPANCAN_IlluminaHiSeq_RNASeqV2.geneExp.tsv` | `expr_pancan.rds` |
| DNA methylation (450k) | `jhu-usc.edu_PANCAN_HumanMethylation450.betaValue_whitelisted.tsv` | `meth_pancan_450k.rds` |
| miRNA expression | `pancanMiRs_EBadjOnProtocolPlatformWithoutRepsWithUnCorrectMiRs_08_04_16.csv` | `mir_pancan.rds` |
| Copy number (SNP6) | `broad.mit.edu_PANCAN_Genome_Wide_SNP_6_whitelisted.seg` | `abs-cn_pancan.tsv` |
| Mutations (MC3) | `mc3.v0.2.8.PUBLIC.maf.gz` | `mut_pancan.maf.gz` |
| RPPA protein | `TCGA-RPPA-pancan-clean.txt` | `rppa_pancan.csv` |
| Purity/ploidy | `TCGA_mastercalls.abs_tables_JSedit.fixed.txt` | `purity-ploidy_pancan.tsv` |
| Clinical outcomes | `clinical_PANCAN_patient_with_followup.tsv` | `clinical_pancan.tsv` |
| QC annotations | `merged_sample_quality_annotations.tsv` | `qc_pancan.tsv` |
| PARADIGM pathway | `merge_merged_reals.tar.gz` | `paradigm_pancan.tar.gz` |

Genome build: **hg19**.

## Requirements

- Linux/macOS
- [gdc-client](https://gdc.cancer.gov/access-data/gdc-data-transfer-tool) for downloading data from GDC
- **R** (>= 3.5) with the following packages:
  - `io` (internal library)
  - `data.table`
  - `org.Hs.eg.db`
  - `IlluminaHumanMethylation450kanno.ilmn12.hg19`

Install R dependencies from Bioconductor:
```r
install.packages(c("data.table", "org.Hs.eg.db",
    "IlluminaHumanMethylation450kanno.ilmn12.hg19"))
```

## Download Data

### Step 1: Download raw files from GDC

```bash
# Install gdc-client if needed
# Download all files listed in the manifest
gdc-client download -m manifest/PanCan-General_Open_GDC-Manifest_2.txt -d gdc
```

This downloads ~50 GB of raw data into `gdc/`.

### Step 2: Symlink raw files into the working directory

```bash
cd rds
bash get.sh
```

This creates symlinks from `gdc/<UUID>/` to human-readable filenames, such as

- `abs-cn_pancan.tsv` — absolute copy number segments
- `clinical_pancan.tsv` — patient clinical data and outcomes
- `qc_pancan.tsv` — sample quality control flags
- `purity-ploidy_pancan.tsv` — tumor purity and ploidy estimates

## Process Data

After symlinking, run the R scripts that you need in the `rds/` directory.

`expr:R` outputs `expr_pancan.rds`: gene expression matrix (genes x samples) with log2-transformed values and Entrez IDs mapped to gene symbols

`meth.R` outputs `meth_pancan_450k.rds`: methylation beta values with CpG island and SNP annotations

`mir.R` outputs `mir_pancan.rds`: miRNA expression matrix

`group.R` outputs sample groupings by cancer type and sample type in `group/`

`median.R` outputs per-group median values

`multiomic.R` outputs `multiomic/<cancer-type>.rds`: per-cancer-type combined multiomic datasets

## Data Sources

All data originates from the [TCGA PanCanAtlas project](https://gdc.cancer.gov/about-data/publications/pancanatlas) hosted at the [NCI GDC](https://portal.gdc.cancer.gov/). Sample annotations are in `annot/`.
