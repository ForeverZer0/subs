module Subs
  class SubRipTime

    def initialize(hour, minute, second, millisecond)
      @ms = millisecond
      @ms += second * 1000
      @ms += minute * 60 * 1000
      @ms += hour * 60 * 60 * 1000
    end

    ZERO = SubRipTime.new(0, 0, 0, 0).freeze

    def total_ms
      @ms
    end

    def -(amount)
      value = amount.is_a?(SubRipTime) ? amount.total_ms : Integer(amount)
      self.class.new(0, 0, 0, [@ms - value, 0].max)
    end

    def +(amount)
      value = amount.is_a?(SubRipTime) ? amount.total_ms : Integer(amount)
      self.class.new(0, 0, 0, [@ms + value, 0].max)
    end

    def hours
      @ms / (1000 * 60 * 60)
    end

    def minutes
      (@ms / (1000 * 60)) % 60
    end

    def seconds
      (@ms / 1000) % 60
    end

    def milliseconds
      @ms % 1000
    end

    def to_s
      "%02d:%02d:%02d,%03d" % [hours, minutes, seconds, milliseconds]
    end
  end
end