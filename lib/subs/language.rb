module Subs

  ##
  # Represents an ISO-639-3 defined language, with conversions from parts 2T, 2B, and 1.
  class Language

    attr_reader :name
    attr_reader :part3
    attr_reader :part2b
    attr_reader :part2t
    attr_reader :part1

    def initialize(name, part3, part2b, part2t, part1)
      @name = name
      @part3 = part3
      @part2b = part2b
      @part2t = part2t
      @part1 = part1
    end

    def ==(other)
      other.is_a?(Language) && @part3 == other.part3
    end

    def self.database
      unless @database
        # Database is a monster (almost 8K LOC), so lazy-load the hell out of it, which overwrites this method
        require_relative 'language_database'
      end
      return database
    end

    def self.to_s
      @part3
    end

    def self.from_part3(code)
      code = format_code(code, 3)
      return code ? database.find { |language| code == language.part3 } : nil
    end

    def self.from_part2b(code)
      code = format_code(code, 3)
      return code ? database.find { |language| code == language.part2b } : nil
    end

    def self.from_part2t(code)
      code = format_code(code, 3)
      return code ? database.find { |language| code == language.part2t } : nil
    end

    def self.from_part1(code)
      code = format_code(code, 2)
      return code ? database.find { |language| code == language.part1 } : nil
    end

    private

    def self.format_code(arg, length)
      code = arg.to_s
      return code.size == length ? code.to_sym : nil
    end
  end
end