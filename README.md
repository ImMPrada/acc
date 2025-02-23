# ACCC - Autodesk Construction Cloud Client

A Ruby client for the Autodesk Construction Cloud API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'accc'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install accc

## Usage

First, configure the client with your API key:

```ruby
ACCC.configure do |config|
  config.api_key = 'your_api_key'
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub.

## License

The gem is available as open source under the terms of the MIT License. 