require "spec"
dir = File.join(File.dirname(__FILE__), '..', 'lib')
require File.join(dir, 'duration_string')

describe "a string representing a duration" do
  before do
    # CuckooTwitterer.send(:include, DurationString)
  end

  it "gives back the number of seconds for seconds" do
    DurationString.to_seconds("17s").should == 17
  end

  it "gives back the number of seconds for dur. strings with only minutes defined" do
    DurationString.to_seconds("7m").should == 7 * 60
  end

  it "gives back the number of seconds for hours for dur. strings with only hours defined" do
    DurationString.to_seconds("4h").should == 60 * 60 * 4
  end

  it "gives back the number of seconds for hours for dur. strings with only days defined" do
    DurationString.to_seconds("2d").should == 60 * 60 * 24 * 2
  end

  it "gives back the number of seconds for hours for dur. strings with only weeks defined" do
    DurationString.to_seconds("3w").should == 60 * 60 * 24 * 7 * 3
  end

end