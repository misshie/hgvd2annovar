require "optparse"

class Hgvd2Bed

  VERSION = "0.1.10"
  HGVD =
    Struct.new( :chr, :position, :rsID_freq,
                :ref, :alt, :num_sample, :filter,
                :mean_depth, :sd_depth, :rr, :ra, :aa, :nr, :na, :gene )

  def judge_types(hgvd)
    # finding left-mached strings: http://d.hatena.ne.jp/takuya_1st/20110909/1315595245
    left_match_size =
      hgvd.ref.split(//).zip(hgvd.alt.split(//)).select{|e|e.uniq.size == 1}.map{|e|e[0]}.join.size
    judged = Hash.new
    judged[:pos] = "#{Integer(hgvd[:position]) + left_match_size}"
    ref2 = hgvd.ref[left_match_size .. -1]
    judged[:ref] = (ref2.empty? ? "-" : ref2)
    alt2 = hgvd.alt[left_match_size .. -1]
    judged[:alt] = (alt2.empty? ? "-" : alt2)
    judged
  end

  # ALT can be multiple alleles.
  # To process the case that ALT consists of SNV and/or INDEL,
  # multiple alleles should be processed independently 
  def process(hgvd)
    # ignoring one of alternative allele counts not found in a multi-allelic site
    na_sum = hgvd.na.split(',').map{|x|x.to_i}.inject(:+)
    hgvd.alt.split(',').each_with_index do |alt,idx|
      hgvd2 = hgvd.dup
      hgvd2.alt = alt
      hgvd2.na = hgvd.na.split(',')[idx] 
      hgvd2.nr = (Integer(hgvd.nr) + na_sum - Integer(hgvd2.na)).to_s 
      process_alt(hgvd2)
    end
  end

  def bedhash
    @bedhash ||= Hash.new
  end

  def process_alt(hgvd)
    judged = judge_types(hgvd)

    case 
    when ((judged[:ref] != "-") && (judged[:alt] != "-")) # SNV (MNP is not supported)
      pos_s = "#{Integer(judged[:pos]) - 1}" # Zero-based half-closed 
      pos_e = judged[:pos]                   # Zero-based half-closed
    when (judged[:ref] == "-") # insertion
      pos_s = "#{Integer(judged[:pos]) - 1}" # Zero-based half-closed 
      pos_e =  "#{Integer(judged[:pos]) - 1}" # Zero-based half-closed
    when (judged[:alt] == "-") # deletion
      pos_s = "#{Integer(judged[:pos]) - 1}"                      # Zero-based half-closed 
      pos_e = "#{Integer(judged[:pos]) + judged[:ref].size - 1}"  # Zero-based half-closed
    else
      $stderr.puts "skipped record: #{hgvd}"
      return
    end
    if hgvd.na.nil? 
      $stderr.puts "NA is not given (AAFeq=0): #{hgvd}"
      hgvd.nr = 1
      hgvd.na = 0
    end

    bedhash["#{hgvd.chr}\t#{pos_s}\t#{pos_e}"] ||= Array.new
    bedhash["#{hgvd.chr}\t#{pos_s}\t#{pos_e}"] << 
      "#{hgvd.ref}>#{hgvd.alt}:%.5f" % (Float(hgvd.na) / (Integer(hgvd.nr) + Integer(hgvd.na))) # AAF
  end

  def run(opts)
    open(ARGV[0], 'r') do |fin|
      fin.each_line do |row|
        row.chomp!
        # next if row.start_with? '#'
        hgvd = HGVD.new(*(row.split("\t")))
        unless opts[:all]
          next unless /PASS|\./ =~ hgvd.filter
        end
        process(hgvd)
      end
    end
    bedhash.each{|k,v| puts "#{k}\t#{v.join(",")}"}
  end

end # class

if __FILE__ == $0
  opts = Hash.new
  ARGV.options do |o|
    o.banner = "ruby #$0 [options] [HGVD.tab]"
    o.separator "Options:"
    o.on("-a", "--all", "use all variants including non-PASS") {|x| opts[:all] = true}
    o.parse!
  end
  Hgvd2Bed.new.run(opts)
end
