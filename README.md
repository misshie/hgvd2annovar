# Hgvd2annovar

Convert 'DBexsome*.tab' file of the Human Genomic Variation Database <http:www.genome.med.kyoto-u.ac.jp/SnpDB/> into 'generic DB file' of the ANNOVAR software package <http://www.openbioinfomatics.org/annovar/>.

## Installation

Just copy `hgvd2annovar.rb` to your working directory. Ruby version 2.0 or 1.9 are recommended. 

## Usage

`ruby hgvd2annovar.rb DBexome20131010.tab > DBexome20131010.tab.txt`

You can also use an option `-a` or `--all`. With these options, output will include non-PASS variants in the filter column.

The output file can be used from ANNOVAR's `annotate_variation.pl` with options `--dbtype generic --genericdbfile DBexome20131010.tab.txt`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

or just contact to the author via email or GitHub. 

## Warning
In gene-hunting projects, a mistake in variant filtering may cause a disaster. Please recheck results from this script by yourself. 

## Copyright
**Copyright**: &copy; MISHIMA, Hiroyuki, 2013 (hmishima (at) nagasaki-u.ac.jp)
**License**: The MIT lisence. See LISENSE.txt for details.

