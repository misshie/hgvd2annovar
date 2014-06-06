# Hgvd2annovar / Hgvd2BED (v 0.1.7)

Convert 'DBexome*.tab' file of the Human Genomic Variation Database <http:www.genome.med.kyoto-u.ac.jp/SnpDB/> into 'generic DB file' of the ANNOVAR software package <http://www.openbioinfomatics.org/annovar/> . Hgvd2BED generates the 4-column BED file.

## ChangeLog

* **BUG-FIX** (Both Hgvd2annovar and Hgvd2BEDv 0.1.7) For example, in non-biallelic sites, allele frequency of the 2nd alternative allele should have been calculated by "(NA2) / (NR+NA1+NA2+NA3)". However, older version calculated by "(NA2) / (NR+NA2)". This bug overestimated allele frequencies in non-biallelic sites.

## Installation

Just copy `lib/hgvd2annovar.rb` or `lib/hgvd2bed.rb` to your working directory. Ruby versions 1.9 or later are recommended. 

## Usage

`ruby hgvd2annovar.rb DBexome20131010.tab > DBexome20131010.tab.txt`

`ruby hgvd2bed.rb DBexome20131010.tab > DBexome20131010.tab.bed`

You can also use an option `-a` or `--all`. With these options, output will include non-PASS variants in the filter column.

The output file can be used from ANNOVAR's `annotate_variation.pl` with options `--dbtype generic --genericdbfile DBexome20131010.tab.txt`.

## Warning
In gene-hunting projects, a mistake in variant filtering may cause a **disaster**. Please recheck results from this script by yourself. The author gratefully welcome your bug reports.

## Copyright
**Copyright**: &copy; MISHIMA, Hiroyuki, 2013-2014 (hmishima (at) nagasaki-u.ac.jp)

**License**: The MIT license. See LICENSE.txt for details.

