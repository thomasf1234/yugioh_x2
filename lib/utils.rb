require 'open-uri'

module YugiohX2Lib
  class Utils
    def self.retry_open(url)
      Ax1Utils::Retry.new(5, 1).start { open(url) }
    end

    def self.download_url(url, dest)
      open(url) do |u|
        File.open(dest, 'wb') { |f| f.write(u.read) }
      end
    end

    def self.positive_integer?(obj)
      obj.kind_of?(Integer) && obj > 0 && obj.integer?
    end

    def self.create_view(name, sql)
      stopwatch = Ax1Utils::Stopwatch.new
      duration = stopwatch.time_it(3) do
        ActiveRecord::Base.connection.execute("DROP VIEW IF EXISTS #{name}")
        ActiveRecord::Base.connection.execute(sql)
        puts "-- create_view(:#{name})"
      end
      puts "   -> #{duration}s"
    end
  end
end
