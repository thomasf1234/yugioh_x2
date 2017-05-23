module YugiohX2
  class BaseController
    def healthcheck(request)
      render json: {message: "Service is online"}.to_json
    end

    def self.before_request(request, response)
      puts "before request"
    end

    def login(request)
      if valid_params?(request.query, ['username', 'password'])
        username = request.query["username"]
        password = request.query["password"]

        if User.exists?(username: username)
          user = User.find_by_username(username)

          if user.session.nil?
            encrypted_password = User.encrypt_password(username, password)

            if encrypted_password == user.encrypted_password
              session_params = { user_id: user.id,
                                 uuid: SecureRandom.uuid,
                                 remote_ip: request.remote_ip,
                                 expires_at: DateTime.now.advance(hours: 1) }

              session = Session.create!(session_params)
              render json: {message: "Welcome back #{user.username}.", uuid: session.uuid}.to_json
            else
              render({json: {message: "invalid username and password"}.to_json}, 401)
            end
          else
            render json: {message: "You are already logged in"}.to_json
          end
        else
          render({json: {message: "invalid username and password"}.to_json}, 401)
        end
      else
        render({json: {message: "invalid request parameters"}.to_json}, 422)
      end
    end

    def logout(request)
      if valid_params?(request.query, ['uuid'])
        uuid = request.query["uuid"]
        session = Session.find_by(uuid: uuid, remote_ip: request.remote_ip)

        if session.nil?
          render({json: {message: "No sessions found for uuid"}.to_json}, 404)
        else
          session.destroy!
          render json: {message: "You have been logged out"}.to_json
        end
      else
        render({json: {message: "invalid request parameters"}.to_json}, 422)
      end
    end

    protected
    def valid_params?(query, keys)
      query.keys.sort == keys.sort
    end

    def render(params, response_code=200)
      if params.has_key?(:json)
        [params[:json], response_code]
      else
        raise "Only json response is supported"
      end
    end

    def logged_in?(uuid, remote_ip)
      Session.where(uuid: uuid, remote_ip: remote_ip)
      session = Session.find_by(uuid: uuid, remote_ip: remote_ip)

      if session.nil? || session.expired?
        false
      else
        true
      end
    end
  end
end