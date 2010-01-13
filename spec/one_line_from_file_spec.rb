require File.join(File.dirname(__FILE__), 'spec_helper')

describe "A cuckoo twitterer with one line from a file" do
  before do
    @twuckoo = Twuckoo::Runner.new(["file"])
    # just so that no files will be written
    @twuckoo.stubs(:store).returns(nil)
    # and the actual text tweets are not tweeted (twittered?)
    @twuckoo.stubs(:send_tweet).returns(true)
  end

  it "stores a line that was sent to it correctly" do
    @twuckoo.lines.should be_empty
    @twuckoo.add_lines("I am happy", "I am sad")
    @twuckoo.lines.should == ["I am happy", "I am sad"]
  end

  it "loads all the lines in the file when sent the load_tweets message" do
    lines = ["I am happy", "I am sad", "I am thrilled", "I am bored"]
    @twuckoo.expects(:get_lines_from_file).returns(lines)
    @twuckoo.load_tweets
    @twuckoo.lines.should == lines
  end

  describe "when it tweeted a line already" do
    before do
      @twuckoo.add_lines("I am happy", "I am sad", "I am thrilled", "I am bored")
      @twuckoo.stubs(:pick).returns(0)
      @twuckoo.tweet(@twuckoo.next)
    end

    it "it removes it" do
      @twuckoo.lines.should == ["I am sad", "I am thrilled", "I am bored"]
    end

    it "stores it" do
      @twuckoo.stubs(:pick).returns(0)
      @twuckoo.expects(:store).with("I am sad")
      @twuckoo.tweet(@twuckoo.next)
    end

    it "it picks an unused line to tweet next" do
      next_pick = @twuckoo.next
      ["I am sad", "I am thrilled", "I am bored"].should include(next_pick)
    end
  end

  it "tweets all the available lines in as many 'rounds' as there are lines" do
    lines = ["I am happy", "I am sad", "I am thrilled", "I am bored"]
    @twuckoo.add_lines(*lines)
    lines.length.times { @twuckoo.tweet(@twuckoo.next) }
    @twuckoo.lines.should be_empty
  end

  it "only reads the file to load lines from the first time around" do
    @twuckoo.stubs(:get_used_lines_from_file).returns([])
    @twuckoo.expects(:get_lines_from_file).returns(["I am happy", "I am sad", "I am thrilled", "I am bored"])
    2.times { @twuckoo.load_lines }
  end

  it "only reads the file to load used lines from the first time around" do
    @twuckoo.stubs(:get_lines_from_file).returns(["I am happy", "I am sad", "I am thrilled", "I am bored"])
    @twuckoo.expects(:get_used_lines_from_file).returns([])
    2.times { @twuckoo.load_lines }
  end

  describe "when loading lines to use" do
    before do
      @twuckoo.stubs(:get_lines_from_file).returns(["I am happy", "I am sad", "I am thrilled", "I am bored"])
      @twuckoo.stubs(:get_used_lines_from_file).returns([])
    end

    it "loads the available ones" do
      @twuckoo.load_lines
      @twuckoo.lines.should == ["I am happy", "I am sad", "I am thrilled", "I am bored"]
    end

    describe "when having used ones from a previous run" do
      before do
        @twuckoo.stubs(:get_used_lines_from_file).returns(["I am happy", "I am sad"])
        @twuckoo.load_lines
      end
      it "should not pick those used lines" do
        @twuckoo.lines.should == ["I am thrilled", "I am bored"]
      end
    end
  end
end
