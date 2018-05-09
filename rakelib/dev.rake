require 'irb'

namespace :dev do
  desc "irb session"
  task :irb do
    ARGV.clear
    IRB.start
  end
end