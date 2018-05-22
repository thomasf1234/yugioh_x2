require 'fileutils'

db_name = "yugioh_x2_#{ENV['ENV']}"
ActiveRecord::Base.logger = Logger.new(File.open("log/#{db_name}.log", 'w+'))

ActiveRecord::Base.establish_connection(
    :adapter => "postgresql",
    :host => "localhost",
    :port => "5432",
    :username => "yugioh_x2",
    :password => "password",
    :database => db_name,
    :encoding => "utf8"
)

require_relative 'schema'
