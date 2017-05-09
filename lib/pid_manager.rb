require 'fileutils'

module YugiohX2Lib
  class PidManager
    PID_FILE = 'tmp/pids/server.pid'

    class << self
      def spawn
        ensure_pid_dir
        if server_running?
          raise YugiohX2::YugiohError.new("server already running!")
        else
          ensure_no_pid_file
          pid = fork do
            begin
              yield
            ensure
              ensure_no_pid_file
            end
          end
          create_pid_file(pid)
          Process.detach(pid)
        end
      end

      # Checks if a process exists
      # @param pid the process id
      def server_running?
        begin
          if File.exists?(PID_FILE)
            pid = read_pid

            if pid.match(/\d+/)
              Process.kill(0, pid.to_i)
              true
            else
              YugiohX2::YugiohError.new("invalid pid found in tmp/pids/server.pid file found")
            end
          else
            false
          end
        rescue Errno::ESRCH # No such process
          false
        rescue Errno::EPERM # The process exists, but you dont have permission to send the signal to it.
          true
        end
      end

      def read_pid
        File.read(PID_FILE).strip
      end

      private
      def ensure_pid_dir
        if !File.directory?("tmp/pids")
          FileUtils.mkdir_p("tmp/pids")
        end
      end

      def create_pid_file(pid)
        if File.exists?(PID_FILE)
          raise YugiohX2::YugiohError.new("tmp/pids/server.pid file found. Exiting...")
        else
          File.open(PID_FILE, 'w') { |file| file.write(pid) }
        end
      end

      def ensure_no_pid_file
        if File.exists?(PID_FILE)
          File.delete(PID_FILE)
        end
      end
    end
  end
end