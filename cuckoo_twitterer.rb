require File.join(File.dirname(__FILE__), 'environments')
require 'twibot'

class CuckooTwitterer
  include CuckooEnvironment
  # the idea is to include a module with a well-defined API with three methods:
  # - load_tweets
  # - next (?next_tweet)
  #
  def tweet
    next_tweet = self.next
    store(next_tweet) unless next_tweet.nil?
    #TODO: tweet the next_tweet
    puts "XXX Testing? #{testing?}"
    if testing?
      puts "XXX Tweeting #{next_tweet}"
    else
      puts "XXX Tweeting #{next_tweet}"
      # twitter.status(:post, next_tweet)
    end
  end

  def run
    load_tweets
    loop do
      tweet
      sleep(1)
    end 
  end

end

