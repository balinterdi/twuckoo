require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Twuckoo::Runner do
  before do
    @twuckoo = Twuckoo::Runner.new
    # actual text tweets should not be tweeted (twittered?)
    @twuckoo.stubs(:send_tweet).returns(true)
  end

  it "waits 1 day between tweets by default" do
    @twuckoo.config[:time_to_sleep].should == "1d"
  end

  it "should not wait between tweets if 0 is given for the time_to_sleep option" do
    @twuckoo.setup do |config|
      config[:time_to_sleep] = "0"
    end
    #TODO: write a custom matcher so this could be written as:
    # @twuckoo.should_not wait_between_tweets
    @twuckoo.wait_between_tweets?.should == false
  end

  it "should wait between tweets if a non-zero value is given for the time_to_sleep option" do
    @twuckoo.setup do |config|
      config[:time_to_sleep] = "1h"
    end
    #TODO: write a custom matcher so this could be written as:
    # @twuckoo.should_not wait_between_tweets    
    @twuckoo.wait_between_tweets?.should == true
  end

  it "can assign vars through the setup method" do
    @twuckoo.setup do |config|
      config[:time_to_sleep] = "3m"
    end
    @twuckoo.config[:time_to_sleep].should == "3m"
  end

  describe "loading values from the config file" do
    it "sets the time interval to wait b/w tweets correctly" do
      @twuckoo.expects(:get_config_values_from_file).returns({ :time_to_sleep => "3m" })
      @twuckoo.setup_from_file
      @twuckoo.config[:time_to_sleep].should == "3m"
    end
  end

  describe "when there is nothing to tweet" do
    before do
      @twuckoo.stubs(:next).returns(nil)
      @twuckoo.stubs(:load_tweets).returns(nil)
    end
    it "does not call store" do
      @twuckoo.expects(:store).never
      @twuckoo.run
    end
  end
  
  describe "when there is nothing more to tweet after a while" do
    before do
      @twuckoo.setup do |config|
        config[:time_to_sleep] = "0"
      end
      @twuckoo.stubs(:next).returns("tweet me this").then.returns(nil)
    end
    it "should send out a notification" do
      @twuckoo.stubs(:send_email).returns(true)
      @twuckoo.expects(:notify).once
      @twuckoo.run
    end
  end
  
end
