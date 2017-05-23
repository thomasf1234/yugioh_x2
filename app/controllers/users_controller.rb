require_relative 'base_controller'

module YugiohX2
  class UsersController < BaseController
    def find(request)
      if valid_params?(request.query, ['uuid'])
        uuid = request.query['uuid']

        if logged_in?(uuid, request.remote_ip)
          session = Session.find_by_uuid(uuid)
          user = session.user
          render json: user.to_json(except: [:id, :encrypted_password])
        else
          render({json: {message: "You are not authorized to make this request"}.to_json}, 401)
        end
      else
        render({json: {message: "invalid request parameters"}.to_json}, 422)
      end
    end
  end
end