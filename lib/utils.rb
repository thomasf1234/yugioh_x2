require 'open-uri'

module YugiohX2Lib
  class Utils
    def self.retry_open(url)
      Retry.new(5, 1).start { open(url) }
    end

    def self.download_url(url, dest)
      open(url) do |u|
        File.open(dest, 'wb') { |f| f.write(u.read) }
      end
    end

    def self.positive_integer?(obj)
      obj.kind_of?(Integer) && obj > 0 && obj.integer?
    end
  end
end
