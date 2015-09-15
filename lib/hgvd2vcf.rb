#!/usr/bin/env ruby

class Hgvd2Vcf
  # ---------------------------------------------------------------------------------------------------------------------
  #   Chr | Position | rsID_freq | Ref | Alt | #Sample | Filter | Mean_depth | SD_depth | RR | RA | AA | NR | NA | Gene
  # ---------------------------------------------------------------------------------------------------------------------
  #     Chr		: Chromosome
  #     Position	: Position
  #     rsID_freq	: dbSNP rsID / known frequency
  #     Ref		: Reference allele
  #     Alt		: Alternative allele
  #     #Sample		: Number of samples covered
  #     Filter		: Filtering status
  #     Mean_depth	: Mean of sample read depth
  #     SD_depth	: Standard deviation of sample read depth
  #     RR		: Number of Ref/Ref genotype
  #     RA		: Number of Ref/Alt genotype
  #     AA		: Number of Alt/Alt genotype
  #     NR		: Number of reference allele
  #     NA		: Number of alternative allele
  #     Gene		: Gene symbol
  HGVD = Struct.new(:chr, :position, :rsID_freq,
                    :ref, :alt, :num_sample, :filter,
                    :mean_depth, :sd_depth, :rr, :ra, :aa, :nr, :na, :gene )
  VCF = Struct.new(:chrom, :pos, :id, :ref, :alt, :qual, :filter, :info, :format, :sample)
  VCF_HEADER = <<'EOF'
##fileformat=VCFv4.1
##ALT=<ID=NON_REF,Description="Represents any possible alternative allele at this location">
##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
##INFO=<ID=AAF,Number=1,Type=Float,Description="Alternative Allele Frequency NA/(NR+NA)">
##INFO=<ID=NUM_SAMPLE,Number=1,Type=Integer,Description="Number of Samples")
##INFO=<ID=MEAN_DEPTH,Number=1,Type=Float,Description="Mean od sample read depth">
##INFO=<ID=SD_DEPTH,Number=1,Type=Float,Description="Standard deviation of sample read depth">
##INFO=<ID=RR,Number=1,Type=Integer,Description="number of Ref/Ref genotype">
##INFO=<ID=RA,Number=1,Type=Integer,Description="number of Ref/Alt genotype">
##INFO=<ID=AA,Number=1,Type=Integer,Description="number of Alt/Alt genotype">
##INFO=<ID=NR,Number=1,Type=Integer,Description="number of referenc allele">
##INFO=<ID=NA,Number=1,Type=Integer,Description="number of alternative allel">
##INFO=<ID=GENE,Number=1,Type=String,Description="gene symbol">
##INFO=<ID=FILTER,Number=1,Type=String,Description="original filter infomation">
##INDO=<ID=RSFREQ,Number=1,Type=String,Description="original rs-id and known frequency information">
EOF
  VCF_COLS = %(# CHROM POS ID REF ALT QUAL FILTER INFO FORMAT HGVDv1_42).join("\t")
  VCF_QUAL = "."
  VCF_FILTER "."
  VCF_FORMAT = "GT"

  def info_field(hgvd)
    info = Array.new
    info << format("AAF=%.6f", (Float(hgvd.na) / (Integer(hgvd.nr) + Integer(hgvd.na))))
    info << "NUM_SAMPLE=#{hgvd.num_sample}"
    info << "MEAN_DEPTH=#{hgvd.mean_depth}"
    info << "SD_DEPTH=#{hgvd.sd_depth}"
    info << "SD_DEPTH=#{hgvd.sd_depth}"
    info << "RR=#{hgvd.rr}"
    info << "RA=#{hgvd.ra}"
    info << "AA=#{hgvd.aa}"
    info << "NR=#{hgvd.nr}"
    info << "NA=#{hgvd.na}"
    info << "GENE=#{hgvd.gene}"
    info << "FILTER=#{hgvd.filter}"
    info << "RSFREQ=#{hgvd.rsID_freq}"
    info.join(";")
  end

  def run 
    puts VCF_HEADER
    puts VCF_COLS
    ARGF.each_line do |row|
      next if row.start_with? '#'
      hgvd = HGVD.new(row.chomp.split("\t")*)
      vcf =vcf.new
      vcf.chrom  = hgvd.chr
      vcf.pos    = hgvd.position
      vcf.id     = hgvd.rsID_freq.split(",").select{|x|x.start_with?('rs')}.join(",")
      vcf.ref    = hgvd.ref
      vcf.alt    = hgvd.alt
      vcf.qual   = VCF_QUAL
      vcf.filter = VCF_FILTER
      vcf.info   = info_field(hgvd)
      vcf.format = VCF_FORMAT
      vcf.sample = "0/1"
      puts vcf.to_a.join("\t")
    end
  end
end

if $0 == __FILE__
  Hgvd2Vcf.new.run
end
