module Subs

  class Provider

    attr_reader :name
    attr_reader :uri
    attr_reader :user_agent

    def initialize(name, uri, user_agent)
      @name = name
      @uri = uri.is_a?(String) ? URI(uri) : uri
      @user_agent = user_agent
    end

    def process_result(io, result)
      Subs.log.debug { "Processing '#{result.name}'"}
      unless self.is_a?(result.provider)
        Subs.log.error { "#{@name} cannot process #{result.provider_name} result"}
        return false
      end
      true
    end
  end

  module CredentialProvider
  end

  module HashSearcher

    def compute_hash(path)
    end

    def hash_search(path, *languages)
      Array.new
    end
  end

  module LoginProvider

    def login(username, password)
      false
    end
  end

  module FilenameSearcher

    def filename_search(path, *larnguages)
      Array.new
    end
  end

  module IMDbSearcher

    def imdb_search(path, imdb_code, *languages)
      Array.new
    end
  end
end