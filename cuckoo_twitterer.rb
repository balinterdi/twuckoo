class CuckooTwitterer

  #TODO: move most of these functions to the module (maybe except the tweet method)
  attr_reader :fodder

  def initialize
    @fodder = []
  end

  def add_fodder(*fodder)
    @fodder.concat(fodder)
  end

  def next
    fodder.delete_at(pick)
  end

  def tweet
    self.next
  end

  def pick
    rand(fodder.length)
  end
end

