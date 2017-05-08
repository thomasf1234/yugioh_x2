module YugiohX2
  module States
    class PreLogin
      def initialize(client)
        @client = client
      end

      def get_options
        [ :login, :exit ]
      end

      def exit
        SocketUtils.write(@client, {response_code: Server::ResponseCode::SUCCESS, message: "Goodbye. Hope to see you again soon"})
      end

      def login
        begin
          SocketUtils.write(@client, {response_code: YugiohX2::Server::ResponseCode::SUCCESS, message: "Please enter your username and password"})

          response = SocketUtils.read(@client, 300)
          if response.has_key?('username') && response.has_key?('password')
            username = response['username']
            password = response['password']
            SLogger.instance.debug("#{@name} : received username:password #{username}:#{password}")
            user = User.find_by_username(username)

            if user.nil?
              SocketUtils.write(@client, {response_code: YugiohX2::Server::ResponseCode::USER_NOT_FOUND, message: "User does not exist"})
              raise UserNotFound
            else
              if user.encrypted_password == User.encrypt_password(username, password)
                SocketUtils.write(@client, {response_code: YugiohX2::Server::ResponseCode::SUCCESS, message: "Welcome back #{username}. Successfully logged in"})
              else
                SocketUtils.write(@client, {response_code: YugiohX2::Server::ResponseCode::AUTHENTICATION_FAILED, message: "Incorrect password. Please enter username and password"})
                raise AuthenticationFailed
              end
            end

            SocketUtils.read(@client, 300)
          else
            raise InvalidAuthenticationResponse
          end
        rescue UserNotFound, AuthenticationFailed
          retry
        rescue InvalidAuthenticationResponse

        end
      end
    end
  end
end