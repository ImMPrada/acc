require 'bundler/setup'
require 'accc'
require 'sinatra'

class DummyApp < Sinatra::Base
  get '/' do
    'ACCC Dummy App'
  end

  get '/test' do
    ACCC.configure do |config|
      config.api_key = ENV.fetch('ACCC_API_KEY', nil)
    end

    'Configuration loaded!'
  end
end

run DummyApp
