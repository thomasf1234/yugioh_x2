db_name = "#{ENV['ENV']}.sqlite3"

ActiveRecord::Base.logger = Logger.new(File.open("log/#{db_name}.log", 'w+'))

ActiveRecord::Base.establish_connection(
    :adapter  => 'sqlite3',
    :database => "db/data/#{db_name}"
)

require_relative 'schema'
