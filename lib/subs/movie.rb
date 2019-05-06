module Subs
  class Movie

    attr_accessor :name
    attr_accessor :year

    def initialize(name, year)
      @name = name
      @year = year
    end
  end
end