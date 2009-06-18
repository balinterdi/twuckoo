require 'rubygems'
require File.join(File.dirname(__FILE__), 'environments')
require File.join(File.dirname(__FILE__), 'duration_string')
require 'twibot'

class Twuckoo
  include TwuckooEnvironment
  # the idea is to include a module with a well-defined API with three methods:
  # - load_tweets
  # - next
  # - store(tweet)
  attr_accessor :time_to_sleep

  def initialize
    @time_to_sleep = "1d"
    super
  end

  def tweet
    next_tweet = self.next
    unless next_tweet.nil? or next_tweet.empty?
      store(next_tweet)
      send_tweet(next_tweet)
    end
    next_tweet
  end

  def get_config_values_from_file
    begin
      open('config/cuckoo.yml', 'r') do |f|
        YAML.load(f.read)
      end
    rescue
      {}
    end
  end

  def setup
    get_config_values_from_file.each_pair do |attr, value|
      self.send("#{attr}=".to_sym, value)
    end
  end

  def relax
    seconds_to_sleep = DurationString.to_seconds(time_to_sleep)
    sleep(seconds_to_sleep)
  end

  def run
    setup
    load_tweets
    loop do
      tweeted = tweet
      quit if tweeted.nil?
      relax
    end
  end

  def quit
    exit
  end
  
  private
  def send_tweet(next_tweet)
    if testing?
      puts "(test) Tweeting #{next_tweet}"
    else
      twitter.status(:post, next_tweet)
    end    
  end
end
