module Subs

  module OpenSubtitles

    OSDB_URI = 'https://api.opensubtitles.org:443/xml-rpc'.freeze
    USER_AGENT = 'subs2'.freeze

    def self.compute_hash(filename)
      File.open(filename, 'rb') do |stream|
        fsize = File.size(filename)
        hash = [fsize & 0xFFFF, (fsize >> 16) & 0xFFFF, 0, 0]
        8192.times { hash = compute_hash_chunk(hash, stream.read(8).unpack('vvvv')) }
        offset = fsize - 0x10000
        stream.seek([0,offset].max, 0)
        8192.times { hash = compute_hash_chunk(hash, stream.read(8).unpack('vvvv')) }
        format('%04x%04x%04x%04x', *hash.reverse)
      end
    end

    def self.compute_hash_chunk(hash, chunk)
      result = [0, 0, 0, 0]
      carry = 0
      hash.zip(chunk).each_with_index do |(h, i), n|
        sum = h + i + carry
        if sum > 0xFFFF
          result[n] += sum & 0xFFFF
          carry = 1
        else
          result[n] += sum
          carry = 0
        end
      end
      result
    end

    def self.connect(language, username = nil, password = nil)
      # Lazy-load XML-RPC gem
      require 'xmlrpc/client'
      if username && password
        password = Digest::MD5.hexdigest(password)
      end
      @client = XMLRPC::Client.new2(OSDB_URI)
      code = language.iso639_1 || language.iso639_2
      result = @client.call('LogIn', username || '', password || '', code, USER_AGENT)
      @token = result['token']
      return @token && @token.size > 1
    end

    def self.disconnect
      return unless @token
      @client.call('LogOut', @token) rescue nil
    end

    def self.hash_search(filename, *languages)
      hash = compute_hash(filename)
      size = File.size(filename).to_s
      langs = languages.map(&:iso639_2).join(',')
      criteria = { 'moviehash' => hash, 'sublanguageid'  => langs, 'moviebytesize' => size }
      search(criteria)
    end

    def self.name_search(filename, *languages)
      langs = languages.map(&:iso639_2).join(',')
      criteria = { 'tag' => File.basename(filename), 'sublanguageid'  => langs }
      search(criteria)
    end

    def self.search(*criteria)
      response = @client.call('SearchSubtitles', @token, criteria, { 'limit' => 20 })
      data = response['data']
      return [] unless data

      data.map do |result|
        name = result['MovieReleaseName']
        language = result['LanguageName']
        link = result['SubDownloadLink']
        format = result['SubFormat']
        SearchResult.new(name, link, language, format)
      end
    end
  end
end