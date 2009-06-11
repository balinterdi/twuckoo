module DurationString
  class << self
    MULTIPLIERS = { "s" => 1, "m" => 60, "h" => 60 * 60, "d" => 60 * 60 * 24, "w" => 60 * 60 * 24 * 7 }
    def to_seconds(duration)
      seconds = 0
      duration.scan(/(\d+)([smhdw])/).each do |num, dur_chr|
        multiplier = MULTIPLIERS[dur_chr]
        seconds = num.to_i * multiplier
      end
      seconds
    end
  end
end