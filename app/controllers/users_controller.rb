require_relative 'application_controller'

module YugiohX2
  class UsersController < ApplicationController
    get '/signup' do
      erb :'/users/signup'
    end
  
    get '/login' do 
      erb :'/users/login'
    end
  
    post '/logout' do 
      session.clear
      redirect '/'
      body("#{current_user.username} logged out")
    end
  
    post '/login' do
      content_type :json
      username = params['username']
      password = params['password']
  
      if YugiohX2::User.exists?(username: username)
        user = YugiohX2::User.find_by_username(username)
        encrypted_password = YugiohX2::User.encrypt_password(username, password)
  
        if encrypted_password == user.encrypted_password
          session[:user_id] = user.id
          { message: "Welcome back #{user.username}" }.to_json
        else
          status(401)
          { message: 'Invalid password' }.to_json
        end
      else
        status(404)
        { message: 'User not found' }.to_json
      end
    end
  
    post '/' do
      content_type :json
      username = params['username']
      password = params['password']
  
      user = YugiohX2::User.find_by_username(username)
      if user.nil?
        encrypted_password = YugiohX2::User.encrypt_password(username, password)
        user = YugiohX2::User.create!({username: username, encrypted_password: encrypted_password})
        session[:user_id] = user.id
        
       { message: "Welcome back #{user.username}." }.to_json
      else
        status(422)
        { message: "User already exists." }.to_json
      end
    end
  
    get '/deposit' do 
       @user = current_user
       erb :'/users/deposit'  
    end
  
    post '/deposit' do 
      content_type :json
  
      if params['amount'].match(/^\d+$/).nil? 
        status(422)
        { message: "amount must be a positive integer." }.to_json
      else
        amount = params['amount'].to_i
  
        @user = current_user
        @user.dp += amount
        @user.save!
  
        { message: "#{@user.username} has been awarded #{amount}dp", new_dp: @user.dp }.to_json
      end
    end

    get '/cards' do 
      cards = current_user.user_cards

      cards.to_json(except: [:id, :user_id]) 
   end

    def cards(request)
      if logged_in?(request)
        user = current_user(request)
        render json: user.user_cards.to_json(except: [:id, :user_id])
      else
        render({json: {message: "You are not authorized to make this request"}.to_json}, 401)
      end
    end
  end
end