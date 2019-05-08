require 'open-uri'
require 'zlib'
require 'digest'
require 'net/http'
require 'cgi'
require 'set'

require_relative 'subs/version'
require_relative 'subs/language'
require_relative 'subs/providers/provider'
require_relative 'subs/providers/sub_db'
require_relative 'subs/providers/open_subtitles'


module Subs

  ##
  # Generic exception class for subtitle related errors.
  class Exception < StandardError
  end

  ##
  # Represents a generic search result for a subtitle
  SearchResult = Struct.new(:provider, :name, :language, :video, :data)

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
      if language.part1
        # ex. MyFavoriteMovie.2019.en.srt
        return true if File.exist?(File.join(dir, "#{base}.#{language.part1}#{ext}"))
      end
      # ex. MyFavoriteMovie.2019.eng.srt
      return true if File.exist?(File.join(dir, "#{base}.#{language.part3}#{ext}"))
    end
    # Not found
    false
  end

  ##
  # Creates a query string to be used within a URI based on specified parameters.
  #
  # @param params [Hash<Symbol, Object>] A hash of keyword arguments that are used to build the query.
  #
  # @return [String] The constructed query string.
  def self.query_string(**params)
    query = ''
    params.each_pair do |key, value|
      next unless value
      query << (query.size.zero? ? '?' : '&')
      query << CGI.escape(key.to_s)
      query << '='
      query << CGI.escape(value.to_s)
    end
    query
  end

  def self.build_subtitle_path(path, language, ext = '.srt')
    dir = File.dirname(path)
    base = File.basename(path, File.extname(path))
    File.join(dir, "#{base}.#{language.part3}#{ext}")
  end

end

eng = Subs::Language.from_part1(:en)


lang = Subs::Language.new('English', 'eng', 'eng', 'eng', 'en')
Subs::OpenSubtitles.new('eric') do |db|
  video = '/storage/movies/Third Person (2013) [1080p]/Third.Person.2013.1080p.BluRay.x264.YIFY.mp4'
  # video = '/home/eric/Downloads/breakdance.avi'

  r = db.hash_search(video, lang).first

  p db.is_a? Subs::HashProvider
end