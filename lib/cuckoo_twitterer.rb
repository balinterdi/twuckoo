require File.join(File.dirname(__FILE__), 'environments')
require 'twibot'
require "ruby-debug"

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

  def run
    load_tweets
    loop do
      tweeted = tweet
      quit if tweeted.nil?
      sleep(24*24*60)
    end
  end

  def quit
    exit
  end
end

