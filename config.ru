#prepend current directory to LOAD_PATH
$:.unshift(".")

require "application"

map('/users') { run YugiohX2::UsersController }
map('/cards') { run YugiohX2::CardsController }
map('/duels') { run YugiohX2::DuelsController }
map('/') { run YugiohX2::ApplicationController }

# /usr/local/bin/ruby2.4/bundle exec puma config.ru