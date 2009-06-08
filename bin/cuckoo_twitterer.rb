dir = File.join(File.dirname(__FILE__), '..')

require File.join(dir, 'cuckoo_twitterer')

Dir.glob(File.join(dir, 'modules', '*.rb')).each do |mod|
  require mod
end

CuckooTwitterer.send(:include, OneLineFromFile)
@cuckoo = CuckooTwitterer.new
# @cuckoo.set_testing
@cuckoo.run
