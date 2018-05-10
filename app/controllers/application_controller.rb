module YugiohX2
  class ApplicationController < Sinatra::Base
    #Listen on all interfaces
    set :bind, '0.0.0.0'
    enable :sessions

    def logged_in?
      !session[:user_id].nil?
    end
  
    def current_user
      YugiohX2::User.find(session[:user_id])
    end
  
    before do
      authenticate
    end
  
    def authenticate
      if !logged_in?
        request_path = request.path
        request_method = request.request_method
        redirect_bool = true
        {
          '/healthcheck' => ['GET'],
          '/users/login' => ['GET', 'POST'],
          '/users/signup' => ['GET'],
          '/users' => ['POST']
        }.each do |endpoint, request_methods|
          if request_path == endpoint && request_methods.include?(request_method)
            redirect_bool = false
            break
          end
        end
  
        if redirect_bool
          redirect :'/users/login'
        end
      end
    end

    get '/healthcheck' do
      { message: "Service is online" }.to_json
    end

    get '/' do
      @user = current_user
      erb :'/users/index'
    end
  end
end