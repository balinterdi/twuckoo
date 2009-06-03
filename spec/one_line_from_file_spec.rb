require "spec"
require File.join(File.dirname(__FILE__), '..', 'cuckoo_twitterer')
require File.join(File.dirname(__FILE__), '..', 'modules', 'one_line_from_file')

class CuckooTwittererWithOneLineFromFileSpec
  describe "A cuckoo twitterer with one line from a file" do
    before do
      CuckooTwitterer.send(:include, OneLineFromFile)
      @cuckoo = CuckooTwitterer.new
    end
    
  end
end
