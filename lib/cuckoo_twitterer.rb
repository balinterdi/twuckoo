require 'rubygems'
require File.join(File.dirname(__FILE__), 'environments')
require File.join(File.dirname(__FILE__), 'duration_string')
require 'twibot'

class CuckooTwitterer
  include CuckooEnvironment
  # the idea is to include a module with a well-defined API with three methods:
  # - load_tweets
  # - next
  # - store(tweet)
  def tweet
    next_tweet = self.next
    unless next_tweet.nil?
      store(next_tweet)
      if testing?
        puts "Tweeting #{next_tweet}"
      else
        twitter.status(:post, next_tweet)
      end
    end
    next_tweet
  end

  def sleep_for(duration)
    sleep(DurationString.to_seconds(duration))
  end

  def run
    load_tweets
    loop do
      tweeted = tweet
      quit if tweeted.nil?
      sleep_for("1d")
    end
  end

  def quit
    exit
  end
end

