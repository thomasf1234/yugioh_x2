# http://stackoverflow.com/questions/16948645/how-do-i-test-a-function-with-gets-chomp-in-it

namespace :admin do
  namespace :server do
    def server_status
      if YugiohX2Lib::PidManager.running?
        puts "server is running with pid: #{YugiohX2Lib::PidManager.read_pid}"
      else
        puts "server is stopped"
      end
    end

    desc "start server"
    task :start do
      server = YugiohX2::Server.new
      YugiohX2Lib::PidManager.spawn { server.start }
      server_status
    end

    desc "server status"
    task :status do
      server_status
    end

    desc "server stop"
    task :stop do
      if YugiohX2Lib::PidManager.running?
        puts "stopping server now"
        begin
          pid = YugiohX2Lib::PidManager.read_pid.to_i
          Process.kill('QUIT', pid)
        rescue Errno::ESRCH
          # process exited normally
        end

        if YugiohX2Lib::PidManager.running?
          raise YugiohX2::YugiohError.new("Server still running!")
        else
          puts "server is stopped"
        end
      else
        puts "server is stopped"
      end
    end
  end
end
