# Hgvd2annovar / Hgvd2BED (beta)

Convert 'DBexome*.tab' file of the Human Genomic Variation Database <http:www.genome.med.kyoto-u.ac.jp/SnpDB/> into 'generic DB file' of the ANNOVAR software package <http://www.openbioinfomatics.org/annovar/> . Hgvd2BED generates a 4-column BED file. CAUTION: Hgvd2BED is under development.

## Installation

Just copy `lib/hgvd2annovar.rb` or `lib/hgvd2bed.rb` to your working directory. Ruby versions 1.9 or later are recommended. 

## Usage

`ruby hgvd2annovar.rb DBexome20131010.tab > DBexome20131010.tab.txt`
`ruby hgvd2bed.rb DBexome20131010.tab > DBexome20131010.tab.bed`

You can also use an option `-a` or `--all`. With these options, output will include non-PASS variants in the filter column.

The output file can be used from ANNOVAR's `annotate_variation.pl` with options `--dbtype generic --genericdbfile DBexome20131010.tab.txt`.

## Warning
In gene-hunting projects, a mistake in variant filtering may cause a **disaster**. Please recheck results from this script by yourself. 

## Copyright
**Copyright**: &copy; MISHIMA, Hiroyuki, 2013-2014 (hmishima (at) nagasaki-u.ac.jp)

**License**: The MIT license. See LICENSE.txt for details.

