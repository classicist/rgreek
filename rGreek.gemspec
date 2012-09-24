# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rgreek/version'

Gem::Specification.new do |gem|
  gem.name          = "rGreek"
  gem.version       = RGreek::VERSION
  gem.authors       = ["Paul Saieg"]
  gem.email         = ["classicist@gmail.com"]
  gem.description   = %q{Light, intuituive ruby tools for working with classical Greek}
  gem.summary       = %q{Light, intuituive ruby tools for working with classical Greek}
  gem.homepage      = "https://github/psaieg/rGreek"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "sqlite3"  
  gem.add_development_dependency "activerecord"  
  gem.add_development_dependency "sinatra"
  gem.add_development_dependency "httparty"    
  gem.add_development_dependency 'nokogiri'
  gem.add_development_dependency 'equivalent-xml'
  gem.add_development_dependency 'nokogiri-diff'

end
