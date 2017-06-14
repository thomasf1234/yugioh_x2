# http://stackoverflow.com/questions/16948645/how-do-i-test-a-function-with-gets-chomp-in-it

=begin
WEBrick is a Ruby library that makes it easy to build an HTTP server with Ruby.
It comes with most installations of Ruby by default (it’s part of the standard library),
so you can usually create a basic web/HTTP server with only several lines of code.
The following code creates a generic WEBrick server on the local machine on port 2000,
shuts the server down if the process is interrupted (often done with Ctrl+C).
Example usage:
GET curl "localhost:2000/cards/search?uuid=fd9bf307-90e3-4bdf-bf38-29ae911766d0&name=Dark%20Magician"
POST curl -H "Content-Type: application/json" -X POST -d '{"some":"xyz","more":"abc"}' localhost:2000/
=end

require "webrick"

namespace :admin do
  namespace :server do
    def server_status
      if YugiohX2Lib::PidManager.server_running?
        puts "server is running with pid: #{YugiohX2Lib::PidManager.read_pid}"
      else
        puts "server is stopped"
      end
    end

    desc "start server in foreground"
    task :start_inline do
      server = WEBrick::HTTPServer.new(RequestCallback: lambda(&YugiohX2::WebrickServlet.method(:before_request)),
                                       Port: 2000)

      server.mount "/", YugiohX2::WebrickServlet

      ['QUIT', 'INT', 'TERM', 'SIGINT'].each do |signal|
        trap(signal) do
          server.shutdown
        end
      end

      server.start
    end

    desc "start server in background"
    task :start do
      server_log = WEBrick::Log.new("log/server.log")
      access_log = [ [ server_log, WEBrick::AccessLog::COMBINED_LOG_FORMAT ] ]

      server = WEBrick::HTTPServer.new(RequestCallback: lambda(&YugiohX2::WebrickServlet.method(:before_request)),
                                       Port: 2000,
                                       Logger: server_log,
                                       AccessLog: access_log)

      server.mount "/", YugiohX2::WebrickServlet

      ['QUIT', 'INT', 'TERM', 'SIGINT'].each do |signal|
        trap(signal) do
          server.shutdown
        end
      end

      YugiohX2Lib::PidManager.spawn { server.start }
      server_status
    end

    desc "server status"
    task :status do
      server_status
    end

    desc "server stop"
    task :stop do
      if YugiohX2Lib::PidManager.server_running?
        begin
          pid = YugiohX2Lib::PidManager.read_pid.to_i
          Process.kill('QUIT', pid)
        rescue Errno::ESRCH
          # process exited normally
        end

        begin
          Ax1Utils::Retry.new(5, 1).start do
            if YugiohX2Lib::PidManager.server_running?
              raise Timeout::Error.new("Server still running!")
            else
              puts "server is stopped"
            end
          end
        rescue Timeout::Error => e
          puts "timed out waiting for server to stop"
        end
      else
        puts "server is stopped"
      end
    end
  end
end
