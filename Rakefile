require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('cuckoo_twitterer', '0.1.3') do |p|
  p.description    = "A simple yet elegant solution to tweet a message regularly from a file (and in the future: from a webpage, a database, etc.)"
  p.url            = "http://github.com/balinterdi/cuckoo_twitterer"
  p.author         = "Bálint Érdi"
  p.email          = "balint@bucionrails.com"
  p.ignore_pattern = ["tmp/*", "script/*", "*.txt", "pkg"]
  p.runtime_dependencies = ["twibot >=0.1.7"]
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

