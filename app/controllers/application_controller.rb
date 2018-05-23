module YugiohX2
  class ApplicationController < Sinatra::Base
    #Listen on all interfaces
    set :bind, '0.0.0.0'
    set :port, 2000
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
          '/internals/login' => ['GET'],
          '/internals/signup' => ['GET'],
          '/users' => ['POST'],
          '/users/login' => ['POST']
        }.each do |endpoint, request_methods|
          if request_path == endpoint && request_methods.include?(request_method)
            redirect_bool = false
            break
          end
        end
  
        if redirect_bool
          redirect :'/internals/login'
        end
      end
    end

    get '/healthcheck' do
      { message: "Service is online" }.to_json
    end

    get '/' do
      @user = current_user
      erb :'/internals/index'
    end
  end
end