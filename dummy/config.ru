require 'bundler/setup'
require 'accc'
require 'sinatra'
require 'dotenv'

Dotenv.load

ACCC.configure do |config|
  config.client_id = ENV.fetch('AUTODESK_CLIENT_ID')
  config.client_secret = ENV.fetch('AUTODESK_CLIENT_SECRET')
  config.callback_url = 'http://localhost:9292/oauth/callback'
  config.scope = 'data:read data:write'
end

class DummyApp < Sinatra::Base
  enable :sessions

  get '/' do
    '<a href="/auth">Login with Autodesk</a>'
  end

  get '/auth' do
    auth = ACCC::Endpoints::Auth.new
    redirect auth.authorization_url
  end

  get '/oauth/callback' do
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
