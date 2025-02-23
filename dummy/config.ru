require 'bundler/setup'
require 'accc'
require 'sinatra'
require 'dotenv'

Dotenv.load

CALLBACK_URL = 'http://localhost:3000/autodesk/callback'.freeze

puts "Using callback URL: #{CALLBACK_URL}"

ACCC.configure do |config|
  config.client_id = ENV.fetch('CLIENT_ID')
  config.client_secret = ENV.fetch('CLIENT_SECRET')
  config.callback_url = CALLBACK_URL
  config.scope = 'data:read'
end

class DummyApp < Sinatra::Base
  enable :sessions

  get '/' do
    '<a href="/auth">Login with Autodesk</a><br>' \
      "Callback URL configured: #{CALLBACK_URL}"
  end

  get '/auth' do
    auth = ACCC::Endpoints::Auth.new
    url = auth.authorization_url
    puts "Generated authorization URL: #{url}"
    redirect url
  end

  get '/autodesk/callback' do
    auth = ACCC::Endpoints::Auth.new
    tokens = auth.exchange_code(params[:code])
    session[:access_token] = tokens['access_token']
    session[:refresh_token] = tokens['refresh_token']

    "Authentication successful!<br>Access Token: #{tokens['access_token']}<br>Refresh Token: #{tokens['refresh_token']}"
  rescue ACCC::Errors::Error => e
    "Authentication failed: #{e.message}"
  end
end

run DummyApp
