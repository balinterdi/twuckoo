require "spec"
require "mocha"

dir = File.join(File.dirname(__FILE__), '..', 'lib')
require File.join(dir, 'cuckoo_twitterer')
require File.join(dir, 'modules', 'wikipedia_tfa')
require File.join(dir, 'environments')

Spec::Runner.configure do |config|
  config.mock_with :mocha
end

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