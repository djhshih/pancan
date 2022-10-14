#!/bin/bash

indir=../gdc

ln -s $indir/3586c0da-64d0-4b74-a449-5ff4d9136611/EBPlusPlusAdjustPANCAN_IlluminaHiSeq_RNASeqV2.geneExp.tsv expr_pancan.tsv

ln -s $indir/d82e2c44-89eb-43d9-b6d3-712732bf6a53/jhu-usc.edu_PANCAN_merged_HumanMethylation27_HumanMethylation450.betaValue_whitelisted.tsv meth_pancan.tsv

ln -s $indir/00a32f7a-c85f-4f86-850d-be53973cbc4d/broad.mit.edu_PANCAN_Genome_Wide_SNP_6_whitelisted.seg cn_pancan.seg

ln -s $indir/99b0c493-9e94-4d99-af9f-151e46bab989/jhu-usc.edu_PANCAN_HumanMethylation450.betaValue_whitelisted.tsv meth_pancan_450k.tsv

ln -s $indir/1c6174d9-8ffb-466e-b5ee-07b204c15cf8/pancanMiRs_EBadjOnProtocolPlatformWithoutRepsWithUnCorrectMiRs_08_04_16.csv mir_pancan.csv

ln -s $indir/fcbb373e-28d4-4818-92f3-601ede3da5e1/TCGA-RPPA-pancan-clean.txt rppa_pancan.csv

ln -s $indir/1c8cfe5f-e52d-41ba-94da-f15ea1337efc/mc3.v0.2.8.PUBLIC.maf.gz mut_pancan.maf.gz

ln -s $indir/4f277128-f793-4354-a13d-30cc7fe9f6b5/TCGA_mastercalls.abs_tables_JSedit.fixed.txt purity-ploidy_pancan.tsv

ln -s $indir/0f4f5701-7b61-41ae-bda9-2805d1ca9781/TCGA_mastercalls.abs_segtabs.fixed.txt abs-cn_pancan.tsv

ln -s $indir/1a7d7be8-675d-4e60-a105-19d4121bdebf/merged_sample_quality_annotations.tsv qc_pancan.tsv

ln -s $indir/7d4c0344-f018-4ab0-949a-09815f483480/merge_merged_reals.tar.gz paradigm_pancan.tar.gz

ln -s $indir/0fc78496-818b-4896-bd83-52db1f533c5c/clinical_PANCAN_patient_with_followup.tsv clinical_pancan.tsv

#55d9bf6f-0712-4315-b588-e6f8e295018e	PanCanAtlas_miRNA_sample_information_list.txt	02bb56712be34bcd58c50d90387aebde	553408
#1b5f413e-a8d1-4d10-92eb-7c4ae739ed81	TCGA-CDR-SupplementalTableS1.xlsx	a4591b2dcee39591f59e5e25a6ce75fa	2945129
