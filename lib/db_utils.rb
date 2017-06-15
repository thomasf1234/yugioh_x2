require 'open-uri'

module YugiohX2Lib
  class DBUtils
    def self.seed(seed_path)
      Ax1Utils.system2("sqlite3 #{database_path} \".read #{seed_path}\"")
    end

    def self.database_path
      ActiveRecord::Base.connection_config[:database]
    end
  end
end
