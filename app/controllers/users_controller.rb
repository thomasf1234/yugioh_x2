require_relative 'base_controller'

module YugiohX2
  class UsersController < BaseController
    def find(request)
      if logged_in?(request)
        user = current_user(request)
        render json: user.to_json(except: [:id, :encrypted_password])
      else
        render({json: {message: "You are not authorized to make this request"}.to_json}, 401)
      end
    end

    def user_cards(request)
      if logged_in?(request)
        user = current_user(request)
        render json: user.user_cards.to_json(except: [:id])
      else
        render({json: {message: "You are not authorized to make this request"}.to_json}, 401)
      end
    end
  end
end