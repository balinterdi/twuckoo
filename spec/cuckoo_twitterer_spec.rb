require "spec"
require File.join(File.dirname(__FILE__), '..', 'cuckoo_twitterer')

class CuckooTwittererSpec
  describe "A cuckoo twitterer" do
    before do
      @cuckoo = CuckooTwitterer.new
    end
    
    it "responds to tweet" do
      @cuckoo.should respond_to(:tweet)
    end
  end
end
