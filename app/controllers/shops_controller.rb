require_relative 'base_controller'

module YugiohX2
  class ShopsController < BaseController
    def password_machine(request)
      if logged_in?(request)
        user = current_user(request)
        body = extract_payload(request)

        if valid_params?(body, ['serial_number'])
          serial_number = body['serial_number']

          if user.dp >= 1000
            card = YugiohX2::Card.find_by_serial_number(serial_number)

            if card.nil?
              render({json: {message: "No card found for serial_number"}.to_json}, 422)
            else
              if user.user_cards.exists?(card_id: card.id)
                user_card = user.user_cards.find_by_card_id(card.id)

                ActiveRecord::Base.transaction do
                  user_card.increment!(:count)
                  user.withdraw(1000)
                end

                #check if successful
                render json: {message: "User has purchased #{user_card.card.name}", card_id: user_card.card_id}.to_json
              else
                render({json: {message: "User does not already possess a copy"}.to_json}, 403)
              end
            end
          else
            render({json: {message: "User does not have enough dp to fulfill the request"}.to_json}, 402)
          end
        else
          render({json: {message: "invalid request parameters"}.to_json}, 422)
        end
      else
        render({json: {message: "You are not authorized to make this request"}.to_json}, 401)
      end
    end
  end
end