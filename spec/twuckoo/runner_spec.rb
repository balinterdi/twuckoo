require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Twuckoo::Runner do
  before do
    @twuckoo = Twuckoo::Runner.new("file")
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

  it "can be made to tweet only a certain number of times" do
    @twuckoo.stubs(:store).returns(nil)
    @twuckoo.stubs(:wait_between_tweets?).returns(false)
    @twuckoo.stubs(:next).returns("tweet me this")
    @twuckoo.setup do |config|
      config[:tweet_limit] = 2
    end
    @twuckoo.expects(:send_tweet).times(2).returns("tweet me this")
    @twuckoo.run
  end

  it "should receive the module to use as the last parameter" do
    runner = Twuckoo::Runner.new('file')
    runner.should respond_to(:reset)
  end

  it "name can be given through the -n option" do
    runner = Twuckoo::Runner.new('file', nil, %w[-n pragthinklearn])
    runner.name.should == "pragthinklearn"
  end

  it "if no name is given, the directory name is used" do
    runner = Twuckoo::Runner.new('file')
    runner.name.should == "twuckoo"
  end

  describe "loading values from the config file" do
    it "sets the time interval to wait b/w tweets correctly" do
      @twuckoo.expects(:get_config_values_from_file).returns({ :time_to_sleep => "3m" })
      @twuckoo.setup_from_file
      @twuckoo.config[:time_to_sleep].should == "3m"
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

  it "tries tweeting again if Twitter is not available" do
    module ShakyTwitter
      i = 0
      define_method :_tweet do |message|
        if i == 0
          i = i + 1
          raise ShakyTwitterException, "Twitter is down. Try again later"
        else
          i = i + 1
          message
        end
      end

      extend self

      class ShakyTwitterException < Exception
      end
      def self.exception
        ShakyTwitterException
      end
    end
    twuckoo = Twuckoo::Runner.new("file", ShakyTwitter)
    twuckoo.stubs(:send_email).returns(true)
    twuckoo.setup do |config|
      config[:tweet_limit] = 2
      config[:time_to_sleep] = "0"
    end
    twuckoo.stubs(:next).returns('Twuckoo 2.0 is coming soonish')
    twuckoo.run
    twuckoo.tweets_sent.should == 2
  end
end
