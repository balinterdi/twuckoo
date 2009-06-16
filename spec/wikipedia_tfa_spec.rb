require File.join(File.dirname(__FILE__), 'spec_helper')

dir = File.join(File.dirname(__FILE__), '..', 'lib')
require File.join(dir, 'modules', 'wikipedia_tfa')

class TwuckooForWikipediaTfaSpec

  extend TwuckooEnvironment
  set_testing

  describe "A cuckoo twitterer for wikipedia featured article" do
    before do
      Twuckoo.send(:include, WikipediaTFA)
      @cuckoo = Twuckoo.new
    end
    it "works" do
      @cuckoo.tweet
    end
  end
end