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
        @cuckoo.stubs(:fodder).returns(["I am happy", "I am sad", "I am thrilled", "I am bored"])
        @cuckoo.stubs(:pick).returns(0)
        @cuckoo.tweet
      end

      it "it removes it" do
        @cuckoo.fodder.should == ["I am sad", "I am thrilled", "I am bored"]
      end

      it "it picks an unused line to tweet next" do
        next_pick = @cuckoo.next
        ["I am sad", "I am thrilled", "I am bored"].should include(next_pick)
      end

    end

    describe "when loading lines to use" do
      before do
        @cuckoo.expects(:get_lines).returns(["I am happy", "I am sad", "I am thrilled", "I am bored"])
        @cuckoo.stubs(:get_used_lines).returns([])        
      end
      
      it "loads the available ones (fodder)" do
        @cuckoo.load_fodder
        @cuckoo.fodder.should == ["I am happy", "I am sad", "I am thrilled", "I am bored"]
      end
      
      describe "when having used ones from a previous run" do
        before do
          @cuckoo.expects(:get_used_lines).returns(["I am happy", "I am sad"])
          @cuckoo.load_fodder
        end
        it "should not pick those used lines" do
          @cuckoo.fodder.should == ["I am thrilled", "I am bored"]
        end
      end
    end
    
  end
end
