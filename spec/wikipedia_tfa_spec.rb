require File.join(File.dirname(__FILE__), 'spec_helper')

dir = File.join(File.dirname(__FILE__), '..', 'lib')
require File.join(dir, 'modules', 'wikipedia_tfa')

class CuckooTwittererForWikipediaTfaSpec

  extend CuckooEnvironment
  set_testing

  describe "A cuckoo twitterer for wikipedia featured article" do
    before do
      CuckooTwitterer.send(:include, WikipediaTFA)
      @cuckoo = CuckooTwitterer.new
    end
    it "works" do
      @cuckoo.tweet
    end
  end
end