require 'open-uri'
require 'zlib'

require_relative 'subs/version'
require_relative 'subs/providers/open_subtitles'
require_relative 'subs/language'

module Subs

  class Exception < StandardError
  end


  def self.download_extract(link, filename)
    begin
      File.open(filename, 'wb') do |io|
        StringIO.open do |buffer|
          open(link, "rb") { |gz| buffer.write(gz.read) }
          buffer.seek(0)
          reader = Zlib::GzipReader.new(buffer)
          io.write(reader.read)
        end
      end
      return true
    rescue
      return false
    end
  end

end
