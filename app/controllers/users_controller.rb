require_relative 'base_controller'

module YugiohX2
  class UsersController < BaseController
    def get(request)
      if logged_in?(request)
        user = current_user(request)
        render json: user.to_json(except: [:id, :encrypted_password])
      else
        render({json: {message: "You are not authorized to make this request"}.to_json}, 401)
      end
    end

    def cards(request)
      if logged_in?(request)
        user = current_user(request)
        render json: user.user_cards.to_json(except: [:id, :user_id])
      else
        render({json: {message: "You are not authorized to make this request"}.to_json}, 401)
      end
    end

    #admin
    #TODO : put check in for negative amount
    def deposit(request)
      body = extract_payload(request)

      if valid_params?(body, ['username', 'amount'])
        username = body['username']
        amount = body['amount']
        user = YugiohX2::User.find_by_username(username)

        if user.nil?
          render({json: {message: "User with username #{username} does not exist"}.to_json}, 404)
        else
          user.dp += amount
          user.save!

          render json: {message: "#{username} has been awarded #{amount}dp"}.to_json
        end
      else
        render({json: {message: "invalid request parameters"}.to_json}, 422)
      end
    end
  end
end