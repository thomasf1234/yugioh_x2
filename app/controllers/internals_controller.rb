require_relative 'application_controller'

module YugiohX2
  class InternalsController < ApplicationController
    get '/signup' do
      erb :'/users/signup'
    end
  
    get '/login' do 
      erb :'/users/login'
    end

    get '/cards' do
      if current_user.admin?
        @cards = YugiohX2::Card.all.sort_by(&:name)
        erb :'/cards/index'
      else
        status(401)
      end
    end

    get '/cards/:id/artworks' do
      id = params[:id]
      @card = YugiohX2::Card.find(id)
      erb :'/cards/artworks'
    end
    
    get '/trunk/:page_index' do 
      card_count = current_user.user_cards.count
      start = params['page_index'].to_i * 50

      @user_cards = current_user.user_cards.limit(50).offset(start)
      erb :'/users/trunk'  
    end

    get '/deposit' do 
      @user = current_user
      erb :'/users/deposit'  
   end
  end
end