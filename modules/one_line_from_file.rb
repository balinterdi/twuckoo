# require 'scrubyt'
require "rubygems"
require 'open-uri'
require "hpricot"

module OneLineFromFile
  # read all lines from the file that contains the strategies
  # select the strategies that are not used yet
  # pick a random strategy

  # store used strategies in a file with (store the md5 sum of the strategies' text)
  attr_reader :fodder

  def initialize
    @fodder = []
  end

  def get_lines_from_file
    IO::readlines('fodder.txt').map { |line| line.chomp }
  end
  
  def get_lines
    @lines ||= get_lines_from_file
  end
  
  def get_used_lines_from_file
    IO::readlines('used_fodder.txt').map { |line| line.chomp }
  end
  
  def get_used_lines
    @used_lines ||=  get_used_lines_from_file
  end
  
  def load_fodder
    used = get_used_lines
    unused_lines = get_lines.select { |line| !used.include?(line) }
    add_fodder(*unused_lines)
  end

  def add_fodder(*fodder)
    @fodder.concat(fodder)
  end

  def pick
    rand(fodder.length)
  end

  def next
    fodder.delete_at(pick)
  end

end

# Daily_Oblique/ZenKoan77
