
module Subs

  module SubDB

    def self.compute_hash(filename)
      size = 64 * 1024
      File.open(filename, 'rb') do |io|
        buffer = io.read(size)
        io.seek(-size, IO::SEEK_END)
        buffer << io.read(size)
        return Digest::MD5.hexdigest(buffer)
      end
    end

    def self.connect


    end


  end
end