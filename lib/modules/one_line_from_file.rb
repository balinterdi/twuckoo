module OneLineFromFile
  # read all lines from the file that contains the strategies
  # select the strategies that are not used yet
  # pick a random strategy

  # store used strategies in a file with (store the md5 sum of the strategies' text)
  attr_reader :lines

  LINES_FILE = 'lines.txt'
  USED_LINES_FILE = 'used_lines.txt'

  def initialize(args=[])
    @lines = []
    # load_lines
  end

  def load_tweets
    load_lines
  end
  
  def get_lines_from_file
    begin
      IO::readlines(LINES_FILE).map { |line| line.chomp }
    rescue Errno::ENOENT
      []
    end
  end

  def get_all_lines
    @fresh_lines ||= get_lines_from_file
  end

  def get_used_lines_from_file
    begin
      IO::readlines(USED_LINES_FILE).map { |line| line.chomp }
    rescue Errno::ENOENT
      []
    end
  end

  def get_used_lines
    @used_lines ||=  get_used_lines_from_file
  end

  def load_lines
    used = get_used_lines
    unused_lines = get_all_lines.select { |line| !used.include?(line) }
    add_lines(*unused_lines)
  end

  def add_lines(*new_lines)
    @lines.concat(new_lines)
  end

  def pick
    rand(lines.length)
  end

  def store(line)
    open(USED_LINES_FILE, "a") do |file|
      file.write(line + "\n")
    end
  end

  def next
    @lines.delete_at(pick)
  end

end

