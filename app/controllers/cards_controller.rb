require_relative 'application_controller'
require 'base64'

module YugiohX2
  class CardsController < ApplicationController
    include URI::Escape

    get '/' do
      @cards = YugiohX2::Card.all.sort_by(&:name)
      erb :'/cards/index'
    end

    get '/:id' do
      content_type :json
      id = params[:id]

      if YugiohX2::Card.exists?(id: id)
        @card = YugiohX2::Card.find(id)
        @card.to_json({include: [:monster_types, :artworks], except: [:id, :card_id]})
      else
        status(404)
        { message: 'Card not found' }.to_json
      end
    end

    get '/:id/artworks' do
      id = params[:id]
      @card = YugiohX2::Card.find(id)
      erb :'/cards/artworks'
    end

    delete '/:id/artworks/:artwork_id' do
      content_type :json
      id = params[:id]
      artwork_id = params[:artwork_id]
    
      if YugiohX2::Card.exists?(id: id)
        card = YugiohX2::Card.find(id)

        if card.artworks.exists?(id: artwork_id)
          artwork = card.artworks.find(artwork_id)
          artwork.destroy!
          { message: 'Artwork deleted' }.to_json
        else
          status(404)
          { message: 'Artwork not found' }.to_json
        end
      else
        status(404)
        { message: 'Card not found' }.to_json
      end
    end
  end
end
