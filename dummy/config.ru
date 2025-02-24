require 'bundler/setup'
require 'acc'
require 'acc/resources/construction_cloud'
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

        <h2>List Issues</h2>
        <form action="/issues" method="get">
          <label for="project_id">Project ID:</label>
          <input type="text" id="project_id" name="project_id" required>
          <button type="submit">List Issues</button>
        </form>
      HTML
    else
      <<~HTML
        <h1>Welcome</h1>
        <p><a href="/auth">Login with Autodesk</a></p>
        <p>Callback URL configured: #{ENV.fetch('CALLBACK_URL', nil)}</p>
      HTML
    end
  end

  get '/issues' do
    return redirect '/auth' unless session[:access_token]
    return 'Project ID is required' unless params[:project_id]

    auth = ACC::Resources::Auth.new(
      access_token: session[:access_token],
      refresh_token: session[:refresh_token]
    )

    issues = ACC::Resources::ConstructionCloud::Issues::Index.new(auth, params[:project_id])
    results = issues.all_paginated

    <<~HTML
      <h1>Issues for Project #{params[:project_id]}</h1>
      <p><a href="/">Back to Home</a></p>

      <table border="1">
        <tr>
          <th>ID</th>
          <th>Title</th>
          <th>Status</th>
          <th>Created At</th>
        </tr>
        #{results.map do |issue|
          <<~TR
            <tr>
              <td>#{issue['id']}</td>
              <td>#{issue['title']}</td>
              <td>#{issue['status']}</td>
              <td>#{issue['createdAt']}</td>
            </tr>
          TR
        end.join}
      </table>
    HTML
  rescue StandardError => e
    "Error: #{e.message}<br><a href='/'>Back to Home</a>"
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
