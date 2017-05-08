require 'socket'
require 'timeout'
require 'json'

# tcp        0      0 0.0.0.0:2000            0.0.0.0:*               LISTEN      4647/irb

# CONNECTION 1
# tcp        0      0 127.0.0.1:2000          127.0.0.1:34286         ESTABLISHED 4647/irb
# tcp        0      0 127.0.0.1:34286         127.0.0.1:2000          ESTABLISHED 4699/irb

# CONNECTION 2
# tcp        0      0 127.0.0.1:34282         127.0.0.1:2000          ESTABLISHED 4699/irb
# tcp        0      0 127.0.0.1:2000          127.0.0.1:34282         ESTABLISHED 4647/irb

module YugiohX2
  class Server
    TIMEOUT = 30

    module ResponseCode
      SUCCESS = '0'
      MAX_CONNECTIONS_REACHED = '1'
      USER_NOT_FOUND = '2'
      INVALID_AUTHENTICATION_RESPONSE = '3'
      AUTHENTICATION_FAILED = '4'
    end

    def initialize(port=2000, max_agents=2)
      @host = 'localhost'
      @port = port
      @max_agents = max_agents
      @clients = Queue.new

      @agents = @max_agents.times.map do |i|
        Agent.new("agent_#{i}", @clients)
      end
    end

    def max_connections_reached?
      @agents.select(&:enabled?).all?(&:occupied?)
    end

    def start
      begin
        server = TCPServer.new(@host, @port)
        SLogger.instance.debug("Starting TCPServer on #{@host}:#{@port}")
        loop do
          #accept a new connection and get a new socket to communicate with client
          client = server.accept

          if max_connections_reached?
            begin
              SLogger.instance.debug("Maximum connections reached. Closing connection")
              SocketUtils.write(client, {response_code: ResponseCode::MAX_CONNECTIONS_REACHED})
            rescue Errno::EPIPE => e
              SLogger.instance.debug("Connection closed by client")
            ensure
              SocketUtils.ensure_close(client)
            end
          else
            begin
              client.setsockopt(Socket::SOL_SOCKET, Socket::SO_KEEPALIVE, true)
              SLogger.instance.debug("Connection established successfully")
              SocketUtils.write(client, {response_code: ResponseCode::SUCCESS, message: "Connection established successfully"})
              @clients.push(client)
            rescue Errno::EPIPE => e
              SLogger.instance.debug("Connection closed by client")
              SocketUtils.ensure_close(client)
            end
          end
        end
      ensure
        SocketUtils.ensure_close(server)
      end
    end
  end
end

