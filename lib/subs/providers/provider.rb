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
      unless self.is_a?(result.provider)
        raise Subs::Exception, 'result cannot be processed by this provider'
      end
    end
  end

  module HashProvider

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

end