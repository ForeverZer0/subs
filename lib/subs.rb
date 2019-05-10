require 'open-uri'
require 'zlib'
require 'digest'
require 'net/http'
require 'cgi'
require 'set'

require_relative 'subs/version'
require_relative 'subs/language'
require_relative 'subs/sub_rip_time'
require_relative 'subs/providers/provider'
require_relative 'subs/providers/sub_db'
require_relative 'subs/providers/open_subtitles'

class String

  # Defines methods for displaying colorized console output, unless already provided by another gem.

  [:red, :green, :yellow, :blue, :pink, :light_blue].each_with_index do |color, i|
    next if method_defined?(color)
    class_eval("def #{color};\"\e[#{i + 31}m\#{self}\e[0m\";end", __FILE__ , __LINE__ )
  end

  ##
  # @!method red
  #   @return [String]

  ##
  # @!method green
  #   @return [String]

  ##
  # @!method yellow
  #   @return [String]

  ##
  # @!method blue
  #   @return [String]

  ##
  # @!method pink
  #   @return [String]

  ##
  # @!method light_blue
  #   @return [String]
end

##
# Top-level namespace for the gem.
module Subs

  ##
  # Represents a generic search result for a subtitle
  SearchResult = Struct.new(:provider_name, :provider, :name, :language, :video, :data)

  ##
  # Represent a movie.
  Movie = Struct.new(:name, :year, :imdb)

  ##
  # Video extensions to search for.
  VIDEO_EXTENSIONS = %w(.avi .mkv .mp4 .mov .mpg .wmv .rm .rmvb .divx).freeze

  ##
  # Subtitle extensions to search for.
  SUB_EXTENSIONS = %w(.srt .sub).freeze

  ##
  # Creates the logger with the specified output stream and verbosity level.
  #
  # @param io [IO] An IO instance that can be written to.
  # @param verbosity [:info|:warn|:error|:fatal|:debug] The logger verbosity level.
  #
  # @return [Logger] the created Logger instance.
  def self.create_log(io = STDOUT, verbosity = :info)
    unless @log
      require 'logger'
      @log = Logger.new(io)
      @log.formatter = proc do |severity, datetime, _, msg|
        "[%s] %s -- %s\n" % [datetime.strftime('%Y-%m-%d %H:%M:%S'), severity, msg]
      end
      @log.level = case verbosity
      when :warn then Logger::WARN
      when :error then Logger::ERROR
      when :fatal then Logger::FATAL
      when :debug then Logger::DEBUG
      else Logger::INFO
      end
    end
    @log
  end

  ##
  # @return [Logger] the logger instance for the module.
  def self.log
    @log ||= create_log(STDOUT)
  end

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
      if language.alpha2
        # ex. MyFavoriteMovie.2019.en.srt
        return true if File.exist?(File.join(dir, "#{base}.#{language.alpha2}#{ext}"))
      end
      # ex. MyFavoriteMovie.2019.eng.srt
      return true if File.exist?(File.join(dir, "#{base}.#{language.alpha3}#{ext}"))
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

  ##
  # Convenience method to attempt getting basic movie information with the specified file.
  #
  # @param path [String] A path to a video file.
  #
  # @return [Movie?] Movie information with result, or `nil` if none could be found.
  def self.fuzzy_search(path)
    return nil unless  File.exist?(path)
    result = nil
    OpenSubtitles.new { |provider| result = provider.fuzzy_search(File.basename(path)) }
    result
  end

  ##
  # Uses the path of a video file to create a path to a matching subtitle file.
  #
  # @param path [String] The path to the video file.
  # @param language [Language] A language for applying a 3-letter language suffix to the file, or `nil` to omit suffix.
  # @param ext [String] The language file extension, including leading dot.
  #
  # @return [String] The created subtitle path.
  def self.build_subtitle_path(path, language = nil, ext = '.srt')
    dir = File.dirname(path)
    base = File.basename(path, File.extname(path))
    if language
      File.join(dir, "#{base}.#{language.alpha3}#{ext}")
    else
      File.join(dir, "#{base}#{ext}")
    end
  end
end

