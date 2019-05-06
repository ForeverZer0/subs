module Subs

  module OpenSubtitles

    OSDB_URI = 'https://api.opensubtitles.org:443/xml-rpc'.freeze
    USER_AGENT = 'TemporaryUserAgent'.freeze

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
        # Extremely lazy-load "digest" gem if needed for generating MD5
        require 'digest'
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

    # TODO

    def hash_search(filename)
      hash = Subs.compute_hash(filename)
      criteria = { 'moviehash' => hash, 'sublanguageid' => @locale.alpha3 }
      search(criteria)
    end

    def search(*criteria)

      @client.call('SearchSubtitles', @token, criteria, { 'timeout' => 20 })

    end


  end

end