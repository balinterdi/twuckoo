require File.join(File.dirname(__FILE__), 'spec_helper')

class TwuckooSpec
  describe "A twuckoo" do
    before do
      @twuckoo = Twuckoo.new
      # actual text tweets should not be tweeted (twittered?)
      @twuckoo.stubs(:send_tweet).returns(true)
    end

    it "responds to tweet" do
      @twuckoo.should respond_to(:tweet)
    end

    it "waits 1 day between tweets by default" do
      @twuckoo.time_to_sleep.should == "1d"
    end

    describe "loading values from the config file" do
      it "sets the time interval to wait b/w tweets correctly" do
        @twuckoo.expects(:get_config_values_from_file).returns({ :time_to_sleep => "3m" })
        @twuckoo.setup
        @twuckoo.time_to_sleep.should == "3m"
      end
    end

    describe "when there is nothing to tweet" do
      before do
        @twuckoo.stubs(:next).returns(nil)
        @twuckoo.stubs(:load_tweets).returns(nil)
      end
      it "does not call store" do
        @twuckoo.expects(:store).never
        @twuckoo.tweet
      end
      it "quits" do
        pending
        @twuckoo.expects(:quit).once
        @twuckoo.run
      end
    end

  end
end
