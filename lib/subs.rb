require 'open-uri'
require 'zlib'
require 'digest'

require_relative 'subs/version'
require_relative 'subs/language'
require_relative 'subs/movie'
require_relative 'subs/search_result'
require_relative 'subs/providers/open_subtitles'
require_relative 'subs/providers/sub_db'

module Subs

  ##
  # Generic exception class for subtitle related errors.
  class Exception < StandardError
  end

  ##
  # Video extensions to search for.
  VIDEO_EXTENSIONS = %w(.avi .mkv .mp4 .mov .mpg .wmv .rm .rmvb .divx).freeze

  ##
  # Subtitle extensions to search for.
  SUB_EXTENSIONS   = %w(.srt .sub).freeze

  ##
  # Searches the specified directory for supported video files.
  #
  # @param directory [String] Path to a directory to search.
  # @param recursive [Boolean] `true` to search recursively within nested directories, otherwise `false`.
  #
  # @return [Array<String>] paths to all found video files.
  #
  def self.video_search(directory, recursive)
    VIDEO_EXTENSIONS.flat_map do |ext|
      Dir.glob(File.join(directory, recursive ? "**/*#{ext}" : "*#{ext}"))
    end
  end

  ##
  # Checks the specified video file for the existence of a subtitles, using common naming conventions and optional
  # language.
  #
  # @param video_path [String] The path to the video file to check.
  # @param language [Language] A specific language to check.
  #
  # @return [Boolean] `true` if a matching subtitle was found, otherwise `false`.
  #
  def self.subtitle_exist?(video_path, language = nil)
    dir = File.dirname(video_path)
    # ex. '/home/me/Videos/MyFavoriteMovie.2019.mp4' => 'MyFavoriteMovie.2019'
    base = File.basename(video_path, File.extname(video_path))
    # Check each supported subtitle extension
    SUB_EXTENSIONS.each do |ext|
      # ex. MyFavoriteMovie.2019.srt
      return true if File.exist?(File.join(dir, "#{base}#{ext}"))
      next unless language
      if language.iso639_1
        # ex. MyFavoriteMovie.2019.en.srt
        return true if File.exist?(File.join(dir, "#{base}.#{language.iso639_1}#{ext}"))
      end
      # ex. MyFavoriteMovie.2019.eng.srt
      return true if File.exist?(File.join(dir, "#{base}.#{language.iso639_2}#{ext}"))
    end
    # Not found
    false
  end

  ##
  # Downloads a GZIP file into memory, and extracts its contents to the specified filename.
  #
  # @param link [String] A full URL of the GZIP file to download.
  # @param filename [String] The file to write the contents to.
  #
  # @return [Boolean] `true` if successful, otherwise `false` if error occurred.
  #
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
