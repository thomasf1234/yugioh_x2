require 'socket'
require 'json'

#Assumed there will always be 1 message response and sent
module YugiohX2
  class Agent < Thread
    def initialize(name, clients)
      @name = name
      @clients = clients
      @occupied = false
      @enabled = true

      super do
        begin
          loop do
            begin
              while client = @clients.pop(true)
                occupy(client) do |client|
                  handle_client(client)
                end
              end
            rescue ThreadError
            end
          end
        rescue Exception => e
          disable
          SLogger.instance.fatal("#{@name} : #{e.class} : #{e.message}")
          SLogger.instance.fatal("#{@name} : #{e.backtrace.join("\n")}")
          raise e
        end
      end
    end

    def handle_client(client)
      begin
        @state = States::PreLogin.new(client)
        SocketUtils.write(client, {options: @state.get_options})
        response = SocketUtils.read(client, 300)
        @state.send(response['option'])


        # http://notahat.com/2014/11/07/state-machines-in-ruby.html
      rescue Timeout::Error, Errno::ECONNRESET
        #if client disconnects, return to waiting
      ensure
        SocketUtils.informed_ensure_close(client)
      end
    end

    def occupy(client)
      begin
        @occupied = true
        yield(client)
      ensure
        @occupied = false
      end
    end

    def occupied?
      @occupied
    end

    def enabled?
      @enabled
    end

    def disable
      @enabled = false
    end
  end
end

