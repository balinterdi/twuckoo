class Twuckoo::Config < Hash
  def initialize
    self[:time_to_sleep] = "1d"
    self[:tweet_limit] = 0
  end
end