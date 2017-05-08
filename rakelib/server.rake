# http://stackoverflow.com/questions/16948645/how-do-i-test-a-function-with-gets-chomp-in-it

namespace :admin do
  namespace :server do
    desc "start server"
    task :start do
      server = YugiohX2::Server.new
      server.start
    end
  end
end