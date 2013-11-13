# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
##require 'hgvd2annovar/version'

Gem::Specification.new do |spec|
  spec.name          = "hgvd2annovar"
  spec.version       = Hgvd2annovar::VERSION
  spec.authors       = ["Hiroyuki Mishima"]
  spec.email         = ["missy@be.to"]
  spec.description   = %q{Convert a HGVD table file into ANNOVAR input file}
  spec.summary       = %q{Convert a HGVD table file into ANNOVAR input file}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
