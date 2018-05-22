require_relative 'application_controller'

module YugiohX2
  class DuelsController < ApplicationController
    get '/' do 
      @duels = YugiohX2::Duel.all
      erb :'/duels/index'
    end

    post '/' do
      @duel = YugiohX2::Duel.create!(user_a_id: current_user.id)

      until @duel.started? do
        @duel.reload
      end

      erb :'/duels/started'
    end

    post '/:id/join' do
      duel_id = params['id']

      if YugiohX2::Duel.exists?(duel_id) 
        @duel = YugiohX2::Duel.find(duel_id)
        @duel.join!(current_user)
      end
   
      erb :'/duels/started'
    end
  end
end