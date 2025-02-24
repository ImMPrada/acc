# ACC - Autodesk Construction Cloud Client

A Ruby client for the Autodesk Construction Cloud API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'acc'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install acc
```

## Requirements

* Ruby 3.3.6 or higher
* Autodesk APS (formerly Forge) credentials:
  * Client ID
  * Client Secret
  * Registered callback URL
  * Appropriate scopes configured

## Usage

### Configuration

First, configure the client with your Autodesk APS credentials:

```ruby
ACC.configure do |config|
  config.client_id = ENV['CLIENT_ID']
  config.client_secret = ENV['CLIENT_SECRET']
  config.callback_url = ENV['CALLBACK_URL']
  config.scope = 'data:read'  # Add required scopes
end
```

### Authentication Flow

The gem implements OAuth 2.0 with 3-legged authentication. Here's how to use it:

1. Generate the authorization URL:

   ```ruby
   auth = ACC::Resources::Auth.new
   authorization_url = auth.authorization_url
   redirect_to authorization_url
   ```

2. Handle the callback:

   ```ruby
   def oauth_callback
     auth = ACC::Resources::Auth.new
     access_token = auth.exchange_code(params[:code])
     # Store tokens securely
     session[:access_token] = access_token
     session[:refresh_token] = auth.refresh_token
   rescue ACC::Errors::AuthError => e
     # Handle authentication errors
     logger.error "Authentication failed: #{e.message}"
     redirect_to auth_failed_path
   end
   ```

3. Refresh expired tokens:

   ```ruby
   def refresh_tokens
     auth = ACC::Resources::Auth.new(refresh_token: session[:refresh_token])
     access_token = auth.refresh_tokens
     # Update stored tokens
     session[:access_token] = access_token
     session[:refresh_token] = auth.refresh_token
   rescue ACC::Errors::AuthError => e
     # Handle refresh errors
     logger.error "Token refresh failed: #{e.message}"
     redirect_to login_path
   end
   ```

### Error Handling

The gem provides specific error classes for different scenarios:

```ruby
begin
  auth.exchange_code(code)
rescue ACC::Errors::MissingScopeError
  # Handle missing scope configuration
rescue ACC::Errors::AccessTokenError
  # Handle expired access token
rescue ACC::Errors::RefreshTokenError
  # Handle expired refresh token
rescue ACC::Errors::AuthError => e
  # Handle other authentication errors
end
```

### Available Scopes

Common scopes include:

* `data:read` - Read access to BIM 360 data
* `data:write` - Write access to BIM 360 data
* `data:create` - Create new items in BIM 360
* `account:read` - Read access to account information
* `account:write` - Write access to account information

## Example Application

The gem includes a dummy Sinatra application that demonstrates the complete
authentication flow. See [dummy/README.md](dummy/README.md) for details.

## External Resources 📚

Useful documentation and references for working with the Autodesk Construction Cloud API:

| Resource | Description |
|----------|-------------|
| [Three-Legged Token Tutorial](https://aps.autodesk.com/en/docs/oauth/v2/tutorials/get-3-legged-token/) | Comprehensive guide on implementing OAuth 2.0 three-legged authentication |
| [Rate Limits Documentation](https://aps.autodesk.com/en/docs/acc/v1/overview/rate-limits/forge-rate-limits/) | Important information about API rate limits and best practices |
| [Issues API Reference](https://aps.autodesk.com/en/docs/acc/v1/reference/http/issues-issues-GET/) | API reference documentation for retrieving issues from projects |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Testing

The test suite uses RSpec. To run all tests:

```bash
bundle exec rspec
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create new Pull Request

Bug reports and pull requests are welcome on GitHub.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
