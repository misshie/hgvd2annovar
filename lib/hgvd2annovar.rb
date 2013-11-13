require "optparse"

class Hgvd2Annovar

  VERSION = "0.0.1"

  HGVD =
    Struct.new( :chr, :position, :rsID_freq,
                :ref, :alt, :num_sample, :filter,
                :mean_depth, :sd_depth, :nr, :na, :gene )

  def judge_types(hgvd)
    # finding left-mached strings: http://d.hatena.ne.jp/takuya_1st/20110909/1315595245
    left_match_size =
      hgvd[:ref].split(//).zip(hgvd[:alt].split(//)).select{|e|e.uniq.size == 1}.map{|e|e[0]}.join.size
    judged = Hash.new
    judged[:pos] = "#{Integer(hgvd[:position]) + left_match_size}"
    ref2 = hgvd[:ref][left_match_size .. -1]
    judged[:ref] = (ref2.empty? ? "-" : ref2)
    alt2 = hgvd[:alt][left_match_size .. -1]
    judged[:alt] = (alt2.empty? ? "-" : alt2)
    judged
  end

  def process(hgvd)
    hgvd[:alt].split(',').each_with_index do |alt,idx|
      hgvd2 = hgvd.dup
      hgvd2[:alt] = alt
      hgvd2[:na] = hgvd[:na].split(',')[idx]
      process_alt(hgvd2)
    end
  end

  def process_alt(hgvd)
    judged = judge_types(hgvd)
    results = Array.new
    results << hgvd[:chr].sub(/\Achr/,'').sub(/\AM/,'MT') # chrom
    case 
    when ((judged[:ref] != "-") && (judged[:alt] != "-")) # SNV (MNP is not supported)
      results << judged[:pos]
      results << judged[:pos]
      results << judged[:ref]
      results << judged[:alt]
    when (judged[:ref] == "-") # insertion
      results << "#{Integer(judged[:pos]) - 1}" 
      results << "#{Integer(judged[:pos]) - 1}" 
      results << judged[:ref]
      results << judged[:alt]
    when (judged[:alt] == "-") # deletion
      results << judged[:pos]
      results << "#{Integer(judged[:pos]) + judged[:ref].size - 1}"
      results << judged[:ref]
      results << judged[:alt]
    end
    results << "%.6f" % (Float(hgvd[:na]) / (Integer(hgvd[:nr]) + Integer(hgvd[:na]))) # AAF
    puts results.join("\t")
  end

  def run(opts)
    open(ARGV[0], 'r') do |fin|
      fin.each_line do |row|
        row.chomp!
        # next if row.start_with? '#'
        process(HGVD.new(*(row.split("\t"))))
      end
    end
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
  Hgvd2Annovar.new.run(opts)
end
