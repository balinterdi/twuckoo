# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twuckoo/version'

Gem::Specification.new do |gem|
  gem.name          = "twuckoo"
  gem.version       = Twuckoo::VERSION
  gem.authors       = ["Balint Erdi"]
  gem.email         = ["balint.erdi@gmail.com"]
  gem.description   = %q{A simple yet elegant solution to tweet a message regularly from a store (file, webpage, etc.)}
  gem.summary       = %q{Need to tweet periodically in an automated fashion? Then Twuckoo is for you!}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'mocha', ['>= 0.9.5']
  gem.add_development_dependency 'rspec', ['~> 2.12.0']
  gem.add_development_dependency 'guard', ['~> 1.5.4']
  gem.add_development_dependency 'guard-rspec', ['~> 2.3.1']
  gem.add_development_dependency 'rb-fsevent', ['~> 0.9.1']
  gem.add_development_dependency 'debugger', ['~> 1.6.1']
  gem.add_development_dependency 'rake', ['~> 10.1.0']

  gem.add_dependency 'twitter_oauth', ['~> 0.4.94']
  gem.add_dependency 'hpricot', ['>= 0.6.164']
  gem.add_dependency 'mail', [">= 1.6.0"]
  gem.add_dependency 'tlsmail', [">= 0.0.1"]
end

