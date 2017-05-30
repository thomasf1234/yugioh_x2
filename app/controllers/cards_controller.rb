require_relative 'base_controller'
require 'base64'

module YugiohX2
  class CardsController < BaseController
    #admin
    def db_names(request)
      db_names = YugiohX2::Card.pluck(:db_name)
      render json: {db_names: db_names}.to_json
    end

    #admin
    def get(request)
      if valid_params?(request.query, ['db_name'])
        db_name = request.query['db_name']
        card = YugiohX2::Card.find_by_db_name(db_name)

        if card.nil?
          render({json: {message: "No card found for db_name"}.to_json}, 422)
        else
          monster_types = card.monster_types.map(&:name)
          artworks = card.artworks
          images = artworks.map do |artwork|
            image_file = File.open(artwork.image_path)
            encoded = Base64.strict_encode64(image_file.read)
            { name: File.basename(artwork.image_path), data: encoded }
          end

          render json: {card: card, monster_types: monster_types, artworks: images}.to_json(except: [:id, :card_id])
        end
      else
        render({json: {message: "invalid request parameters"}.to_json}, 422)
      end
    end
  end
end
