
module Subs

  class SubDB < Provider

    include HashSearcher

    def initialize(&block)
      agent = "SubDB/1.0 (subs/#{Subs::VERSION}; http://github.com/ForeverZer0/subs)"
      super('TheSubDB.com', URI('http://api.thesubdb.com/'), agent)
      yield self if block_given?
    end

    def compute_hash(path)
      size = 64 * 1024
      File.open(path, 'rb') do |io|
        buffer = io.read(size)
        io.seek(-size, IO::SEEK_END)
        buffer << io.read
        return Digest::MD5.hexdigest(buffer)
      end
    end

    def process_result(io, result)
      return false unless super
      hash = result.data
      lang = result.language.alpha2
      request = Net::HTTP::Get.new(@uri.path + Subs.query_string(action: :download, hash: hash, language: lang ))
      request['User-Agent'] = @user_agent
      begin
        Net::HTTP.start(@uri.host, @uri.port) do |net|
          response = net.request(request)
          return false unless response.code.to_i == 200
          io.write(response.body)
          Subs.log.debug { 'Success'.green }
          return true
        end
      rescue
        Subs.log.debug { 'Failed'.red }
        return false
      end
    end

    def hash_search(path, *languages)
      results = []
      unless File.exist?(path)
        Subs.log.error { "Cannot search, cannot find '#{path}'" }
        return results
      end
      hash = compute_hash(path)
      Subs.log.debug { "Searching #{@name.blue} by hash using '#{hash}'" }
      supported = supported_languages(hash)
      languages.each do |language|
        next unless supported.include?(language)
        name = File.basename(Subs.build_subtitle_path(path, language))
        results << Subs::SearchResult.new(@name, self.class, name, language, path, hash)
      end
      Subs.log.debug { "Found #{results.size.to_s.light_blue} result(s)." }
      results
    end

    def supported_languages(hash)
      request = Net::HTTP::Get.new(@uri.path + Subs.query_string(action: 'search', hash: hash))
      request['User-Agent'] = @user_agent
      Net::HTTP.start(@uri.host, @uri.port) do |net|
        body = net.request(request).body
        body.split(',').map { |value| Subs::Language.from_alpha2(value) }.compact
      end
    end

    def all_supported_languages
      request = Net::HTTP::Get.new(@uri.path + Subs.query_string(action: 'languages'))
      request['User-Agent'] = @user_agent
      Net::HTTP.start(@uri.host, @uri.port) do |net|
        body = net.request(request).body
        body.split(',').map { |value| Subs::Language.from_alpha2(value) }.compact
      end
    end
  end
end