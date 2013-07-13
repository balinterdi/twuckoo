module Twuckoo
  class Config < Hash
    #TODO: Get rid of this mess
    def initialize
      self[:time_to_sleep] = "1d"
      self[:tweet_limit] = 0
    end
  end
end
