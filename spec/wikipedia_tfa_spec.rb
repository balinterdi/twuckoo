require File.join(File.dirname(__FILE__), 'spec_helper')

dir = File.join(File.dirname(__FILE__), '..', 'lib')
require File.join(dir, 'modules', 'wikipedia_tfa')

class TwuckooForWikipediaTfaSpec

  describe "A cuckoo twitterer for wikipedia featured article" do
    before do
      Twuckoo.send(:include, WikipediaTFA)
      @twuckoo = Twuckoo.new
      # should not actually send out any tweets
      @twuckoo.stubs(:send_tweet).returns(true)
      @twuckoo.stubs(:time_to_sleep).returns("1s")
      @twuckoo.stubs(:send_email).returns(true)
    end

    it "should not tweet the same thing twice subsequently" do
      @twuckoo.stubs(:get_last_tweet).returns("Twitter: http://en.wikipedia.org/wiki/Twitter")
      @twuckoo.stubs(:fetch_tfa).returns("Twitter: http://en.wikipedia.org/wiki/Twitter")
      @twuckoo.stubs(:next).returns(@twuckoo.get_last_tweet).then.
                           returns(@twuckoo.fetch_tfa).then.
                           returns(nil)
      @twuckoo.expects(:send_tweet).once
      @twuckoo.run
    end
  end
end