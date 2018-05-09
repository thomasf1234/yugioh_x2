ENV['ENV'] ||= 'development'
$log_name = ENV['ENV']

Bundler.require(:default, ENV['ENV'])
require 'yaml'
require 'sinatra'

ROUTES = YAML.load_file("config/routes.yaml")

require 'fileutils'
FileUtils.mkdir('log') unless File.directory?('log')

require 'active_record'
Dir["lib/**/*.rb"].each { |file| require_relative file }
require_relative 'db/initialize'
require_relative 'db/schema'

Dir["app/exceptions/**/*.rb"].each { |file| require_relative file }
Dir["app/**/*.rb"].each { |file| require_relative file }
Dir["db/**/*.rb"].each { |file| require_relative file }


class Application < Sinatra::Base
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

  get '/' do
    if logged_in?
      body("Welcome #{current_user.username}")
    else
      body("Welcome")
    end
  end

  get '/users/signup' do
    erb :'/users/signup'
  end

  get '/users/login' do 
    erb :'/users/login'
  end

  get '/users/logout' do 
    session.clear
    redirect '/'
    body("#{current_user.username} logged out")
  end

  post '/users/login' do
    username = params['username']
    password = params['password']

    if YugiohX2::User.exists?(username: username)
      user = YugiohX2::User.find_by_username(username)
      encrypted_password = YugiohX2::User.encrypt_password(username, password)

      if encrypted_password == user.encrypted_password
        session[:user_id] = user.id
        redirect '/'
      else
        status(401)
        body('Invalid password')
      end
    else
      status(404)
      body('User not found')
    end
  end

  post '/users' do
    content_type :json
    username = params['username']
    password = params['password']

    user = YugiohX2::User.find_by_username(username)
    if user.nil?
      encrypted_password = YugiohX2::User.encrypt_password(username, password)
      user = YugiohX2::User.create({username: username, encrypted_password: encrypted_password})
      session[:user_id] = user.id
      
     { message: "Welcome back #{user.username}." }.to_json
    else
      status(422)
      body('User already exists')
    end
  end
end

Application.run!



# http://www.yugioh-card.com/uk/rulebook/Rulebook_v9_en.pdf


