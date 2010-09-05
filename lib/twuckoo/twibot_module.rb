require 'twibot'

module Twuckoo::Twibot

  def self._tweet
    twitter.status(:post, message)
  end

end
