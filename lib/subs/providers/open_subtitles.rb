module Subs
  class OpenSubtitles < Provider

    include HashProvider
    include LoginProvider

    def initialize(username = nil, password = nil)
      require 'xmlrpc/client'
      super('OpenSubtitles.org', URI('https://api.opensubtitles.org:443/xml-rpc'), 'subs2')
      @client = XMLRPC::Client.new2(@uri)
      login(username, password)
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
        warn "Failed to login to #{name}" if code == 401
        @token = response['token']
        return @token && @token.size > 0
      rescue
        return false
      end
    end

    def logout
      @client.call(:LogOut, @token) rescue nil
    end

    def process_result(io, result)
      super
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
        return true
      rescue
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
      (hash & 0xFFFFFFFFFFFFFFFF).to_s(16).rjust(16)
    end

    def hash_search(path, *languages)
      return [] unless File.exist?(path)
      lang = languages.map(&:part3).join(',')
      hash = compute_hash(path)
      size = File.size(path)

      params = { moviehash: hash, moviebytesize: size, sublanguageid: lang }

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
            language = Subs::Language.from_part3(result['SubLanguageID'])
            link = result['SubDownloadLink']
            results << Subs::SearchResult.new(self.class, name, language, path, link)
          end
        end
        return results
      rescue
        return []
      end
    end
  end
end
