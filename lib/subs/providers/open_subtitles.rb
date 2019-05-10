module Subs
  class OpenSubtitles < Provider

    include HashSearcher
    include LoginProvider
    include FilenameSearcher
    include IMDbSearcher
    include CredentialProvider

    def initialize(username = nil, password = nil)
      require 'xmlrpc/client'
      super('OpenSubtitles.org', URI('https://api.opensubtitles.org:443/xml-rpc'), 'subs2')
      @client = XMLRPC::Client.new2(@uri)
      Subs.log.debug { "Connected to #{@name.blue} using token '#{@token}'" } if login(username, password)
      if block_given?
        yield self
        logout
      end
    end

    def login(username = nil, password = nil)
      password = Digest::MD5.hexdigest(password) if username && password
      begin
        response = @client.call(:LogIn, username || '', password || '', 'en', @user_agent)
        code = response['code'].to_i
        if code == 501
          Subs.log.error { 'Server is currently under maintenance, try again later,'.yellow }
        elsif code == 401
          Subs.log.warn { "Failed to login to #{@name.blue}" }
        end
        @token = response['token']
        return @token && @token.size > 0
      rescue
        Subs.log.error { "Failed to connect to #{@name.blue}" }
        return false
      end
    end

    def logout
      @client.call(:LogOut, @token) rescue nil
      Subs.log.debug { "Disconnected from #{@name.blue}" }
    end

    def process_result(io, result)
      return false unless super
      begin
        # Use a string buffer for downloaded data to eliminate need for storing compressed file on disk
        StringIO.open do |buffer|
          open(result.data, "rb") { |src| buffer.write(src.read) }
          buffer.seek(0, IO::SEEK_SET)
          # Read the buffer and copy the decompressed GZIP stream to the output stream
          gz = Zlib::GzipReader.new(buffer)
          io.write(gz.read)
          gz.close
        end
        Subs.log.debug { 'Success'.green }
        return true
      rescue
        Subs.log.debug { 'Failed'.red }
        return false
      end
    end

    def compute_hash(path)
      hash = File.size(path)
      File.open(path, 'rb') do |io|
        hash += io.read(65536).unpack('Q*').sum
        io.seek(-65536, IO::SEEK_END)
        hash += io.read(65536).unpack('Q*').sum
      end
      (hash & 0xFFFFFFFFFFFFFFFF).to_s(16).rjust(16, '0')
    end

    def hash_search(path, *languages)
      unless File.exist?(path)
        Subs.log.error { "Cannot search, cannot find '#{path}'" }
        return []
      end
      lang = languages.map(&:alpha3).join(',')
      hash = compute_hash(path)
      Subs.log.debug { "Searching #{@name.blue} by hash using '#{hash}'" }
      size = File.size(path)
      params = { moviehash: hash, moviebytesize: size, sublanguageid: lang }
      search(path, params)
    end

    def filename_search(path, *languages)
      unless File.exist?(path)
        Subs.log.error { "Cannot search, cannot find '#{path}'" }
        return []
      end
      movie = fuzzy_search(path)
      return [] unless movie
      imdb_search(path, movie.imdb, *languages)
    end

    def imdb_search(path, imdb_id, *languages)
      lang = languages.map(&:alpha3).join(',')
      Subs.log.debug { "Searching #{@name.blue} by IMDb ID using '#{imdb_id}'" }
      params = { imdbid: imdb_id, sublanguageid: lang }
      search(path, params)
    end

    def search(path, *criteria)
      @limit ||= { limit: 10 }
      results = []
      begin
        response = @client.call(:SearchSubtitles, @token, criteria, @limit)
        if response['status'] == '200 OK'
          response['data'].each do |result|
            name = result['SubFileName']
            language = Subs::Language.from_alpha3(result['SubLanguageID'])
            link = result['SubDownloadLink']
            results << Subs::SearchResult.new(@name, self.class, name, language, path, link)
          end
        end
        Subs.log.debug { "Found #{results.size.to_s.light_blue} result(s)." }
        return results
      rescue
        Subs.log.error { "An error occurred processing request." }
        return []
      end
    end

    def fuzzy_search(query)
      q = File.exist?(query) ? File.basename(query) : query
      Subs.log.debug { "Performing fuzzy search using '#{q}'" }
      begin
        response = @client.call(:GuessMovieFromString, @token, [query])
        result = response['data'].first.last['BestGuess']
        name = result['MovieName']
        year = result['MovieYear'].to_i
        imdb = result['IDMovieIMDB']
        Subs.log.debug { 'Success'.green }
        return Subs::Movie.new(name, year, imdb)
      rescue
        Subs.log.debug { "Failed".red }
        return nil
      end
    end
  end
end
