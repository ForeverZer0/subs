
module Subs

  class SubDB < Provider

    include HashProvider

    def initialize(&block)
      agent = "SubDB/1.0 (subs2/#{Subs::VERSION}; http://github.com/ForeverZer0/subs)"
      super('TheSubDB.com', URI('http://api.thesubdb.com/'), agent)
      yield self if block_given?
    end

    def compute_hash(path)
      size = 64 * 1024
      return nil unless File.exist?(path) && File.size(path) >= size

      File.open(path, 'rb') do |io|
        buffer = io.read(size)
        io.seek(-size, IO::SEEK_END)
        buffer << io.read
        return Digest::MD5.hexdigest(buffer)
      end
    end

    def process_result(io, result)
      super
      hash = result.data
      lang = result.language.part1
      request = Net::HTTP::Get.new(@uri.path + Subs.query_string(action: :download, hash: hash, language: lang ))
      request['User-Agent'] = @user_agent
      begin
        Net::HTTP.start(@uri.host, @uri.port) do |net|
          response = net.request(request)
          return false unless response.code.to_i == 200
          io.write(response.body)
        end
      rescue
        return false
      end
      true
    end

    def hash_search(path, *languages)
      results = []
      hash = compute_hash(path)
      return results unless hash
      supported = supported_languages(hash)
      languages.each do |language|
        next unless supported.include?(language)
        name = File.basename(Subs.build_subtitle_path(path, language))
        results << Subs::SearchResult.new(self.class, name, language, path, hash)
      end
      results
    end

    def supported_languages(hash)
      request = Net::HTTP::Get.new(@uri.path + Subs.query_string(action: 'search', hash: hash))
      request['User-Agent'] = @user_agent
      Net::HTTP.start(@uri.host, @uri.port) do |net|
        body = net.request(request).body
        body.split(',').map { |value| Subs::Language.from_part1(value) }.compact
      end
    end
  end
end