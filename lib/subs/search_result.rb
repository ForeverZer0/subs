module Subs
  class SearchResult

    attr_reader :name
    attr_reader :link
    attr_reader :language
    attr_reader :format

    def initialize(name, link, language, format, **options)
      @name = name
      @link = link
      @language = language
      @format = format
    end
  end
end