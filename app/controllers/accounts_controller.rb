require_relative 'base_controller'

module YugiohX2
  class AccountsController < BaseController
    def login(request)
      body = extract_payload(request)

      if valid_params?(body, ['username', 'password'])
        username = body["username"]
        password = body["password"]

        if User.exists?(username: username)
          user = User.find_by_username(username)
          encrypted_password = User.encrypt_password(username, password)

          if encrypted_password == user.encrypted_password
            session_params = {user_id: user.id,
                              uuid: SecureRandom.uuid,
                              remote_ip: request.remote_ip,
                              expires_at: DateTime.now.advance(hours: 1)}


            current_session = current_session(request)

            if current_session.nil? && user.session.nil?
              session = Session.create!(session_params)
            else
              session = user.session
              session.update_attributes!(session_params)
              session.reload
            end

            render json: {message: "Welcome back #{user.username}.", uuid: session.uuid}.to_json
          else
            render({json: {message: "invalid username and password"}.to_json}, 401)
          end
        else
          render({json: {message: "invalid username and password"}.to_json}, 401)
        end
      else
        render({json: {message: "invalid request parameters"}.to_json}, 422)
      end
    end

    def logout(request)
      session = current_session(request)

      if session.nil?
        render({json: {message: "No sessions found for uuid"}.to_json}, 404)
      else
        session.destroy!
        render json: {message: "You have been logged out"}.to_json
      end
    end
  end
end