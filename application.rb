ENV['ENV'] ||= 'development'
$log_name = ENV['ENV']

Bundler.require(:default, ENV['ENV'])
require 'yaml'

ROUTES = YAML.load_file("config/routes.yaml")

require 'fileutils'
FileUtils.mkdir('log') unless File.directory?('log')

require 'active_record'
Dir["lib/**/*.rb"].each { |file| require_relative file }
require_relative 'db/initialize'
require_relative 'db/schema'

Dir["app/exceptions/**/*.rb"].each { |file| require_relative file }
Dir["app/**/*.rb"].each { |file| require_relative file }
Dir["db/**/*.rb"].each { |file| require_relative file }


# http://www.yugioh-card.com/uk/rulebook/Rulebook_v9_en.pdf


