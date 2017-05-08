require 'socket'
require 'json'

module YugiohX2
  class Client
    def initialize(host, port)
      @host = host
      @port = port
      @os = STDOUT #StringIO.new
    end

    def connect
      socket = nil

      begin
        socket = TCPSocket.new(@host, @port)
        response = SocketUtils.read(socket, 300)
        puts response
        require 'pry'; binding.pry
      ensure
        SocketUtils.ensure_close(socket)
      end
    end

    def write(socket, hash)
      SocketUtils.write(socket, hash)
      response = SocketUtils.read(socket, 300)
    end

    # def connect
    #   socket = nil
    #
    #   begin
    #     socket = TCPSocket.new(@host, @port)
    #
    #     response = SocketUtils.read(socket, 300)
    #
    #     case response['response_code']
    #       when Server::ResponseCode::MAX_CONNECTIONS_REACHED
    #         raise MaxConnectionsReached
    #       when Server::ResponseCode::SUCCESS
    #         # @os.puts(response['message'])
    #         #
    #         # response = SocketUtils.read(socket, 300)
    #         # @os.puts(response['message'])
    #         # username, password = get_userpass
    #         #
    #         # #send username/password
    #         # SocketUtils.write(socket, {username: username, password: password})
    #         # response = SocketUtils.read(socket, 300)
    #         # @os.puts(response['message'])
    #
    #         require 'pry'; binding.pry
    #         case response['response_code']
    #           when Server::ResponseCode::SUCCESS
    #             response = SocketUtils.read(socket, 300)
    #           when Server::ResponseCode::USER_NOT_FOUND
    #             response = SocketUtils.read(socket, 300)
    #           when Server::ResponseCode::AUTHENTICATION_FAILED
    #             response = SocketUtils.read(socket, 300)
    #           else
    #             raise YugiohError.new("unknown response code")
    #         end
    #         @os.puts(response["message"])
    #
    #
    #       else
    #         raise "Unkown response code"
    #     end
    #   ensure
    #
    #     SocketUtils.ensure_close(socket)
    #   end
    # end

    private
    def get_userpass
      @os.print "Username: "
      username = gets.chomp
      password = STDIN.getpass("Password: ")
      return username, password
    end
  end
end
