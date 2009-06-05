class CuckooTwitterer
  # the idea is to include a module with a well-defined API with three methods:
  # - load_tweets
  # - next (?next_tweet)
  #
  def tweet
    next_tweet = self.next
    #TODO: tweet the next_tweet
  end
  
  def run
    load_tweets
    tweet # in loop?
  end

end

