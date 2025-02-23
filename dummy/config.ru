require 'bundler/setup'
require 'acc'
require 'sinatra'
require 'dotenv'

Dotenv.load

puts "Using callback URL: #{ENV.fetch('CALLBACK_URL', 'Not configured!')}"

ACC.configure do |config|
  config.client_id = ENV.fetch('CLIENT_ID')
  config.client_secret = ENV.fetch('CLIENT_SECRET')
  config.callback_url = ENV.fetch('CALLBACK_URL')
  config.scope = ENV.fetch('SCOPE', 'data:read')
end

class DummyApp < Sinatra::Base
  enable :sessions

  get '/' do
    if session[:access_token]
      <<~HTML
        <h1>Authenticated!</h1>
        <p>Access Token: #{session[:access_token]}</p>
        <p>Refresh Token: #{session[:refresh_token]}</p>
        <p><a href="/refresh">Refresh Tokens</a></p>
        <p><a href="/logout">Logout</a></p>
      HTML
    else
      <<~HTML
        <h1>Welcome</h1>
        <p><a href="/auth">Login with Autodesk</a></p>
        <p>Callback URL configured: #{ENV['CALLBACK_URL']}</p>
      HTML
    end
  end

  get '/auth' do
    auth = ACC::Resources::Auth.new
    url = auth.authorization_url
    puts "Generated authorization URL: #{url}"
    redirect url
  end

  get '/autodesk/callback' do
    auth = ACC::Resources::Auth.new
    access_token = auth.exchange_code(params[:code])
    session[:access_token] = access_token
    session[:refresh_token] = auth.refresh_token

    redirect '/'
  rescue ACC::Errors::AuthError => e
    "Authentication failed: #{e.message}"
  end

  get '/refresh' do
    return redirect '/auth' unless session[:refresh_token]

    auth = ACC::Resources::Auth.new(refresh_token: session[:refresh_token])
    access_token = auth.refresh_tokens
    session[:access_token] = access_token
    session[:refresh_token] = auth.refresh_token

    redirect '/'
  rescue ACC::Errors::AuthError => e
    session.clear
    "Token refresh failed: #{e.message}<br><a href='/auth'>Login again</a>"
  end

  get '/logout' do
    session.clear
    redirect '/'
  end
end

run DummyApp
