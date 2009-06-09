require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('cuckoo_twitterer', '0.0.1') do |p|
  p.description    = "A simple yet elegant solution to tweet a message regularly from a file (and in the future: from a webpage, a database, etc.)"
  p.url            = "http://github.com/balinterdi/cuckoo_twitterer"
  p.author         = "Bálint Érdi"
  p.email          = "balint.erdi@bucionrails.com"
  p.ignore_pattern = ["tmp/*", "script/*", "lib/*.txt"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

