require File.join(File.dirname(__FILE__), 'spec_helper')

dir = File.join(File.dirname(__FILE__), '..', 'lib')
require File.join(dir, 'modules', 'one_line_from_file')

# use mocha for mocking instead of
# Rspec's own mock framework
Spec::Runner.configure do |config|
  config.mock_with :mocha
end

class TwuckooWithOneLineFromFileSpec

  extend TwuckooEnvironment
  set_testing

  describe "A cuckoo twitterer with one line from a file" do
    before do
      Twuckoo.send(:include, OneLineFromFile)
      @cuckoo = Twuckoo.new
      # just so that no files will be written
      @cuckoo.stubs(:store).returns(nil)
    end

    it "stores a line that was sent to it correctly" do
      @cuckoo.lines.should be_empty
      @cuckoo.add_lines("I am happy", "I am sad")
      @cuckoo.lines.should == ["I am happy", "I am sad"]
    end

    it "loads all the lines in the file when sent the load_tweets message" do
      lines = ["I am happy", "I am sad", "I am thrilled", "I am bored"]
      @cuckoo.expects(:get_lines_from_file).returns(lines)
      @cuckoo.load_tweets
      @cuckoo.lines.should == lines
    end

    describe "when it tweeted a line already" do
      before do
        @cuckoo.add_lines("I am happy", "I am sad", "I am thrilled", "I am bored")
        @cuckoo.stubs(:pick).returns(0)
        @cuckoo.tweet
      end

      it "it removes it" do
        @cuckoo.lines.should == ["I am sad", "I am thrilled", "I am bored"]
      end

      it "stores it" do
        @cuckoo.stubs(:pick).returns(0)
        @cuckoo.expects(:store).with("I am sad")
        @cuckoo.tweet
      end

      it "it picks an unused line to tweet next" do
        next_pick = @cuckoo.next
        ["I am sad", "I am thrilled", "I am bored"].should include(next_pick)
      end
    end

    it "tweets all the available lines in as many 'rounds' as there are lines" do
      lines = ["I am happy", "I am sad", "I am thrilled", "I am bored"]
      @cuckoo.add_lines(*lines)
      lines.length.times { @cuckoo.tweet }
      @cuckoo.lines.should be_empty
    end

    it "only reads the file to load lines from the first time around" do
      pending
      @cuckoo.stubs(:get_used_lines_from_file).returns([])
      @cuckoo.expects(:get_lines_from_file).returns(["I am happy", "I am sad", "I am thrilled", "I am bored"])
      2.times { @cuckoo.load_lines }
    end

    it "only reads the file to load used lines from the first time around" do
      pending
      @cuckoo.stubs(:get_lines_from_file).returns(["I am happy", "I am sad", "I am thrilled", "I am bored"])
      @cuckoo.expects(:get_used_lines_from_file).returns([])
      2.times { @cuckoo.load_lines }
    end

    describe "when loading lines to use" do
      before do
        @cuckoo.stubs(:get_lines_from_file).returns(["I am happy", "I am sad", "I am thrilled", "I am bored"])
        @cuckoo.stubs(:get_used_lines_from_file).returns([])
      end

      it "loads the available ones" do
        @cuckoo.load_lines
        @cuckoo.lines.should == ["I am happy", "I am sad", "I am thrilled", "I am bored"]
      end

      describe "when having used ones from a previous run" do
        before do
          @cuckoo.stubs(:get_used_lines_from_file).returns(["I am happy", "I am sad"])
          @cuckoo.load_lines
        end
        it "should not pick those used lines" do
          @cuckoo.lines.should == ["I am thrilled", "I am bored"]
        end
      end
    end

  end
end
