module YugiohX2
  class CardController < BaseController
    def search(request)
      search_params = request.query
      cards = Card.where(search_params)
      render json: cards.to_json
    end
  end
end