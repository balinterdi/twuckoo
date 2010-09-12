require 'twitter_oauth/client'
require 'twitter_oauth'

module Twuckoo::TwitterOauth

  def self._tweet(message, options)
    @client ||= TwitterOAuth::Client.new(
      :consumer_key => options[:consumer_key],
      :consumer_secret => options[:consumer_secret],
      :token => options[:oauth_token],
      :secret => options[:oauth_token_secret]
    )
    @client.update(message)
  end

end
