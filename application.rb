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

JQUERY_VERSION='3.3.1'
jquery_url = "https://ajax.googleapis.com/ajax/libs/jquery/#{JQUERY_VERSION}/jquery.min.js"

require 'open-uri'
jquery_dir = File.join("public/js/jquery", JQUERY_VERSION)
jquery_path = File.join(jquery_dir, 'jquery.min.js')

require 'fileutils'
FileUtils.mkdir_p(jquery_dir)
if !File.exist?(jquery_path)
  download = open(jquery_url)
  IO.copy_stream(download, jquery_path)
end

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
    @user = current_user
    erb :'/users/index'
  end

  get '/users/signup' do
    erb :'/users/signup'
  end

  get '/users/login' do 
    erb :'/users/login'
  end

  post '/users/logout' do 
    session.clear
    redirect '/'
    body("#{current_user.username} logged out")
  end

  post '/users/login' do
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
      { message: "User already exists." }.to_json
    end
  end

  get '/users/deposit' do 
     @user = current_user
     erb :'/users/deposit'  
  end

  post '/users/deposit' do 
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
end

Application.run!



# http://www.yugioh-card.com/uk/rulebook/Rulebook_v9_en.pdf


