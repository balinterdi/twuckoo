require "spec"
dir = File.join(File.dirname(__FILE__), '..', 'lib')
require File.join(dir, 'cuckoo_twitterer')
require File.join(dir, 'environments')

class CuckooTwittererSpec
  extend CuckooEnvironment
  set_testing

  describe "A cuckoo twitterer" do
    before do
      @cuckoo = CuckooTwitterer.new
    end

    it "responds to tweet" do
      @cuckoo.should respond_to(:tweet)
    end

    it "waits 1 day between tweets by default" do
      @cuckoo.time_to_sleep.should == "1d"
    end

    describe "loading values from the config file" do
      it "sets the time interval to wait b/w tweets correctly" do
        @cuckoo.expects(:get_config_values_from_file).returns({ :time_to_sleep => "3m" })
        @cuckoo.setup
        @cuckoo.time_to_sleep.should == "3m"
      end
    end

    describe "when there is nothing to tweet" do
      before do
        @cuckoo.stubs(:next).returns(nil)
        @cuckoo.stubs(:load_tweets).returns(nil)
      end
      it "does not call store" do
        @cuckoo.expects(:store).never
        @cuckoo.tweet
      end
      it "quits" do
        pending
        @cuckoo.expects(:quit).once
        @cuckoo.run
      end
    end
  end
end
