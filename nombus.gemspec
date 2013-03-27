# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nombus/version'

Gem::Specification.new do |gem|
  gem.name          = "nombus"
  gem.version       = Nombus::Version
  gem.authors       = ["Adam Griffin"]
  gem.email         = ["adam.griffin@windermeresolutions.com"]
  gem.description   = %q{Check a CSV file for domain names that are not managed by Windermere DNS servers.}
  gem.summary       = %q{Nombus can be used to check if a list of domain names that have been input for agent websites are managed by Windermere's nameservers or managed elsewhere. It can capture a list of these domain names in another csv fiel for further processing. Also, Nombus is useful for capturing domain names that are not valid, not registerd, or not pointed at Windermere's agent websites at all.}
  gem.homepage      = "http://www.windermere.com/"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib", "config"]
  gem.add_development_dependency('rdoc')
  gem.add_development_dependency('aruba')
  gem.add_development_dependency('rspec')
  gem.add_development_dependency('rake', '~> 0.9.2')
  gem.add_development_dependency('pry')
  gem.add_development_dependency('pry-debugger')
  gem.add_dependency('methadone', '~> 1.2.4')
  gem.add_dependency('dnsruby')
  gem.add_dependency('public_suffix')
  gem.add_dependency('whois')
  gem.add_dependency('rainbow')
end
