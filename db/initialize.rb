require 'fileutils'

DATA_DIRECTORY = File.join("db/data", ENV['ENV'])
FileUtils.mkdir_p(DATA_DIRECTORY)

db_name = "#{ENV['ENV']}.sqlite"
ActiveRecord::Base.logger = Logger.new(File.open("log/#{db_name}.log", 'w+'))

ActiveRecord::Base.establish_connection(
    :adapter  => 'sqlite3',
    :database => File.join(DATA_DIRECTORY, db_name),
    :pool => 30
)

require_relative 'schema'
