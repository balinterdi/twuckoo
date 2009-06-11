module DurationString
  class << self
    MULTIPLIERS = { "s" => 1, "m" => 60, "h" => 60 * 60, "d" => 60 * 60 * 24, "w" => 60 * 60 * 24 * 7 }
    def to_seconds(duration)
      duration.scan(/(\d+)([smhdw])/).inject(0) do |seconds, match|
        num, dur_chr = match
        multiplier = MULTIPLIERS[dur_chr]
        seconds + num.to_i * multiplier
      end
    end
  end
end