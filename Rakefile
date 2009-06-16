require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('twuckoo', '0.2.1') do |p|
  p.description    = "A simple yet elegant solution to tweet a message regularly from a file (and in the future: from a webpage, a database, etc.)"
  p.url            = "http://github.com/balinterdi/twuckoo"
  p.author         = "Bálint Érdi"
  p.email          = "balint@bucionrails.com"
  p.ignore_pattern = ["tmp/*", "script/*", "*.txt", "pkg"]
  p.runtime_dependencies = ["twibot >=0.1.7"]
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

