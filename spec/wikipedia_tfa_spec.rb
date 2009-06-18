require File.join(File.dirname(__FILE__), 'spec_helper')

dir = File.join(File.dirname(__FILE__), '..', 'lib')
require File.join(dir, 'modules', 'wikipedia_tfa')

class TwuckooForWikipediaTfaSpec

  extend TwuckooEnvironment
  set_testing

  describe "A cuckoo twitterer for wikipedia featured article" do
    before do
      Twuckoo.send(:include, WikipediaTFA)
      @twuckoo = Twuckoo.new
    end
    
    it "works" do
      @twuckoo.tweet
    end
    
    it "should not tweet the same thing twice subsequently" do
      @twuckoo.expects(:get_last_tweet).returns("Twitter: http://en.wikipedia.org/wiki/Twitter")
      @twuckoo.expects(:fetch_tfa).returns("Twitter: http://en.wikipedia.org/wiki/Twitter")
      @twuckoo.expects(:send_tweet).never
      @twuckoo.tweet
    end    
  end
end