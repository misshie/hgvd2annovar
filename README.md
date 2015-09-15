# Hgvd2annovar / Hgvd2BED / Hgvd2VCF (v 0.1.9)

Convert 'DBexome*.tab' file of the Human Genomic Variation Database <http:www.genome.med.kyoto-u.ac.jp/SnpDB/> into 'generic DB file' of the ANNOVAR software package <http://www.openbioinfomatics.org/annovar/> . Hgvd2BED generates the 4-column BED file.

## ChangeLog
* **NEW but beta** hgvd2vcf.rb converts HGVDr1.42 data into a VCF file. DO NOT USE FOR IMPORTANT PROJECTS. 
* **UPDATE** Supports release version 1.42 (2014.06.17). This release contains new three columns (RR/RA/AA). Newly added loci in this release may have just "." in the filter column. Hgvd2annovar.rb and Hgvd2BED.rb handle them as same as "PASS". 

* **BUG-FIX** (Both Hgvd2annovar and Hgvd2BEDv 0.1.7) For example, in non-biallelic sites, allele frequency of the 2nd alternative allele should have been calculated by "(NA2) / (NR+NA1+NA2+NA3)". However, older version calculated by "(NA2) / (NR+NA2)". This bug overestimated allele frequencies in non-biallelic sites.

## Installation

Just copy `lib/hgvd2annovar.rb` `lib/hgvd2bed.rb` or `lib/hgvd2vcf.rb` to your working directory. Ruby versions 1.9 or later are recommended. 

For your convenience, converted datasets are available in the `public_data` directory.

## Usage

`ruby hgvd2annovar.rb DBexome20131010.tab > DBexome20131010.tab.txt`

`ruby hgvd2bed.rb DBexome20131010.tab > DBexome20131010.tab.bed`

`ruby hgvd2vcf.rb DBexome20131010.tab > DBexome20131010.tab.vcf` (no option is supprted)

You can also use an option `-a` or `--all`. With these options, output will include non-PASS variants in the filter column.

The output file can be used from ANNOVAR's `annotate_variation.pl` with options `--dbtype generic --genericdbfile DBexome20131010.tab.txt`.

## Warning
In gene-hunting projects, a mistake in variant filtering may cause a **disaster**. Please recheck results from this script by yourself. The author gratefully welcome your bug reports.

## Copyright
**Copyright**: &copy; MISHIMA, Hiroyuki, 2013-2015 (hmishima (at) nagasaki-u.ac.jp)

**License**: The MIT license. See LICENSE.txt for details.

