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
