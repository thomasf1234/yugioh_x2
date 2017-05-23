require_relative 'base_controller'

module YugiohX2
  class CardController < BaseController
    def search(request)
      if valid_params?(request.query, ['uuid', 'name'])
        uuid = request.query['uuid']
        name = request.query['name']

        if logged_in?(uuid, request.remote_ip)
          cards = Card.where(name: name)
          render json: cards.to_json
        else
          render({json: {message: "You are not authorized to make this request"}.to_json}, 401)
        end
      else
        render({json: {message: "invalid request parameters"}.to_json}, 422)
      end
    end
  end
end