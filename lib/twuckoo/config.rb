class Twuckoo::Config < Hash
  def initialize
    self[:time_to_sleep] = "1d"
  end
end