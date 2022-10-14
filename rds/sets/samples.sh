#!/bin/bash

indir=../../gdc

# extract sample names from header fielders
function extract_samples {
	head -n 1 $1 |
		cut -f 2- |
		tr '\t' '\n' |
		tr -d '"' |
		sed 1d \
		> $2
}

extract_samples $indir/*/jhu-usc.edu_PANCAN_HumanMethylation450.betaValue_whitelisted.tsv meth-samples.vtr
extract_samples $indir/*/EBPlusPlusAdjustPANCAN_IlluminaHiSeq_RNASeqV2.geneExp.tsv expr-samples.vtr

