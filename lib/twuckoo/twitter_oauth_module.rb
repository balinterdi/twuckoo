require 'twitter_oauth/client'
require 'twitter_oauth'

module Twuckoo::TwitterOauth

  def self._tweet(message, options)
    client(options).update(message)
  end

  def self.latest_tweet(options)
    last_tweet = client(options).home_timeline.first
    last_tweet['text'] if last_tweet
  end

private
  def self.client(options)
    @client ||= TwitterOAuth::Client.new(
      :consumer_key => options[:consumer_key],
      :consumer_secret => options[:consumer_secret],
      :token => options[:oauth_token],
      :secret => options[:oauth_token_secret]
    )
  end

end
