require "spec"
require "mocha"

require File.join(File.dirname(__FILE__), '..', 'cuckoo_twitterer')
require File.join(File.dirname(__FILE__), '..', 'modules', 'one_line_from_file')

# use mocha for mocking instead of
# Rspec's own mock framework
Spec::Runner.configure do |config|
  config.mock_with :mocha
end

class CuckooTwittererWithOneLineFromFileSpec
  describe "A cuckoo twitterer with one line from a file" do
    before do
      CuckooTwitterer.send(:include, OneLineFromFile)
      @cuckoo = CuckooTwitterer.new
      # @cuckoo.add_fodder("I am happy", "I am sad", "I am thrilled", "I am bored")
    end

    it "stores a line that was sent to it correctly" do
      @cuckoo.fodder.should be_empty
      @cuckoo.add_fodder("I am happy", "I am sad")
      @cuckoo.fodder.should == ["I am happy", "I am sad"]
    end

    describe "when it tweeted a line already" do
      before do
        @cuckoo.stubs(:fodder).returns(["I am happy", "I am sad"])
        @cuckoo.stubs(:pick).returns(0)
        @cuckoo.tweet
      end

      it "it removes it" do
        @cuckoo.fodder.should == ["I am sad"]
      end

      it "it picks an unused line to tweet next" do
        @cuckoo.next.should == "I am sad"
      end

    end

    it "returns the used lines correctly" do
      @cuckoo.stubs(:use).returns()
      @cuckoo
    end

  end
end
