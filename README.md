# ACCC - Autodesk Construction Cloud Client

A Ruby client for the Autodesk Construction Cloud API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'accc'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install accc
```

## Requirements

* Ruby 3.3.6 or higher
* Autodesk APS (formerly Forge) credentials
* Client ID
* Client Secret
* Registered callback URL

## Usage

### Configuration

First, configure the client with your Autodesk APS credentials:

```ruby
ACCC.configure do |config|
  config.client_id = 'your_client_id'
  config.client_secret = 'your_client_secret'
  config.callback_url = 'your_callback_url'
  config.scope = 'data:read'  # Add required scopes
end
```

### Authentication

The gem uses OAuth 2.0 with 3-legged authentication. See
[Authentication Documentation](lib/accc/endpoints/README.md) for detailed information.

Basic example:

```ruby
# Generate authorization URL
auth = ACCC::Endpoints::Auth.new
redirect_to auth.authorization_url

# Handle callback
auth = ACCC::Endpoints::Auth.new
tokens = auth.exchange_code(params[:code])
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

### Running the Example App

The gem includes a dummy Sinatra application that demonstrates the authentication
flow:

1. Configure your credentials in `dummy/.env`:

```ascii
CLIENT_ID=your_client_id
CLIENT_SECRET=your_client_secret
```

1. Run the application:

```bash
cd dummy
bundle install
bundle exec rackup -p 3000
```

1. Visit [http://localhost:3000](http://localhost:3000) and click "Login with
   Autodesk"

## Testing

The test suite uses RSpec. To run all tests:

```bash
bundle exec rspec
```

## Contributing

1. Fork it
1. Create your feature branch (`git checkout -b feature/my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin feature/my-new-feature`)
1. Create new Pull Request

Bug reports and pull requests are welcome on GitHub.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
