# ACC - Autodesk Construction Cloud Client

A Ruby client for the Autodesk Construction Cloud API.

## Table of Contents

- [Installation](#installation)
- [Requirements](#requirements)
- [Configuration](#configuration)
- [Usage](#usage)
  - [Authentication](#authentication)
  - [Working with Issues](#working-with-issues)
  - [Error Handling](#error-handling)
  - [Available Scopes](#available-scopes)
- [Example Application](#example-application)
  - [Demo App Documentation](dummy/README.md)
- [External Resources](#external-resources-)
- [Development](#development)
- [Testing](#testing)
  - [Running Tests](#running-tests)
  - [VCR Cassettes](#vcr-cassettes)
    - [Managing Cassettes](#managing-cassettes)
    - [Recording Successful Cassettes](#recording-successful-cassettes)
    - [Re-recording Cassettes](#re-recording-cassettes)
    - [Creating New Cassettes](#creating-new-cassettes)
- [Contributing](#contributing)
- [License](#license)

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

- Ruby 3.3.6 or higher
- Autodesk APS (formerly Forge) credentials:
  - Client ID
  - Client Secret
  - Registered callback URL
  - Appropriate scopes configured

## Configuration

Before using the gem, you need to configure it with your Autodesk APS credentials:

```ruby
ACC.configure do |config|
  # Required configuration
  config.client_id = ENV['ACC_CLIENT_ID']
  config.client_secret = ENV['ACC_CLIENT_SECRET']
  config.callback_url = ENV['ACC_CALLBACK_URL']
  
  # Optional configuration
  config.scope = ['data:read', 'account:read'] # Default: ['data:read']
end
```

It's recommended to use environment variables for sensitive credentials. You can
also use a `.env` file:

```bash
# .env
ACC_CLIENT_ID=your_client_id
ACC_CLIENT_SECRET=your_client_secret
ACC_CALLBACK_URL=https://your-app.com/oauth/callback
```

## Usage

### Authentication

The gem implements OAuth 2.0 with 3-legged authentication:

```ruby
# Initialize the auth client
auth = ACC::Resources::Auth.new

# Generate authorization URL for user consent
authorization_url = auth.authorization_url
redirect_to authorization_url

# Handle the OAuth callback
def oauth_callback
  auth = ACC::Resources::Auth.new
  begin
    # Exchange the code for tokens
    access_token = auth.exchange_code(params[:code])
    
    # Store tokens securely
    session[:access_token] = access_token
    session[:refresh_token] = auth.refresh_token
  rescue ACC::Errors::AuthError => e
    # Handle authentication errors
    logger.error "Authentication failed: #{e.message}"
  end
end

# Refresh expired tokens
def refresh_tokens
  auth = ACC::Resources::Auth.new(refresh_token: session[:refresh_token])
  begin
    access_token = auth.refresh_tokens
    session[:access_token] = access_token
    session[:refresh_token] = auth.refresh_token
  rescue ACC::Errors::RefreshTokenError => e
    # Handle refresh errors
    logger.error "Token refresh failed: #{e.message}"
  end
end
```

### Working with Issues

```ruby
# Initialize the auth client with your access token
auth = ACC::Resources::Auth.new(access_token: session[:access_token])

# Get issues for a project
issues_client = ACC::Resources::ConstructionCloud::Issues::Index.new(auth, project_id)

# Get all issues (handles pagination automatically)
all_issues = issues_client.all_paginated

# Process the issues
all_issues.each do |issue|
  puts "Issue ID: #{issue['id']}"
  puts "Title: #{issue['title']}"
  puts "Status: #{issue['status']}"
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
  puts "Authentication error: #{e.message}"
end
```

### Available Scopes

Common scopes include:

- `data:read` - Read access to BIM 360 data
- `data:write` - Write access to BIM 360 data
- `data:create` - Create new items in BIM 360
- `account:read` - Read access to account information
- `account:write` - Write access to account information

For more details about available endpoints and functionality, check the
[API Reference Documentation](https://aps.autodesk.com/en/docs/acc/v1/reference/http/).

## Example Application

The gem includes a dummy Sinatra application that demonstrates the complete
authentication flow. See [dummy/README.md](dummy/README.md) for details.

## External Resources 📚

Useful documentation and references for working with the Autodesk Construction
Cloud API:

| Resource | Description |
|----------|-------------|
| [Three-Legged Token Tutorial] | Guide on implementing OAuth 2.0 auth |
| [Rate Limits Documentation] | Information about API rate limits |
| [Issues API Reference] | API reference for retrieving issues |

[Three-Legged Token Tutorial]: https://aps.autodesk.com/en/docs/oauth/v2/tutorials/get-3-legged-token/
[Rate Limits Documentation]: https://aps.autodesk.com/en/docs/acc/v1/overview/rate-limits/forge-rate-limits/
[Issues API Reference]: https://aps.autodesk.com/en/docs/acc/v1/reference/http/issues-issues-GET/

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Testing

### Running Tests

To run all tests:

```bash
bundle exec rspec
```

To run specific tests:

```bash
bundle exec rspec path/to/spec_file
```

> **Note**: When running existing tests, no real credentials are needed as VCR
> will use the recorded cassettes.

### VCR Cassettes

The project uses VCR for recording and replaying HTTP interactions in tests.
VCR cassettes are stored in `spec/vcr_cassettes/`.

#### Managing Cassettes

- **New Cassettes**: Created automatically when running specs with `:vcr` tag
- **Sensitive Data**: The following data is automatically filtered in cassettes:
  - `<CLIENT_ID>`
  - `<CLIENT_SECRET>`
  - `<ACCESS_TOKEN>`
  - `<REFRESH_TOKEN>`
  - `<PROJECT_ID>`

#### Recording Successful Cassettes

Credentials are **only needed when recording new cassettes** or re-recording
existing ones. For regular test runs, no real credentials are required.

To record cassettes with successful API interactions, you need to provide valid
credentials and project ID. You can do this by setting environment variables
when running the specs:

```bash
CLIENT_ID=your_client_id \
CLIENT_SECRET=your_client_secret \
PROJECT_ID=your_project_id \
bundle exec rspec
```

You can also store these in a `.env` file:

```bash
# .env
CLIENT_ID=your_client_id
CLIENT_SECRET=your_client_secret
PROJECT_ID=your_project_id
```

> **Note**: Make sure not to commit your `.env` file with real credentials to
> version control.

#### Re-recording Cassettes

To re-record a specific cassette:

1) Delete the cassette file
2) Run the spec again

To re-record all cassettes:

1) Delete all files in `spec/vcr_cassettes/`
2) Run the full test suite

#### Creating New Cassettes

Add `:vcr` metadata to your spec and run it. VCR will automatically record the
HTTP interactions:

```ruby
describe '#my_method', :vcr do
  it 'does something' do
    # your test here
  end
end
```

## Contributing

1) Fork it
2) Create your feature branch
3) Commit your changes
4) Push to the branch
5) Create new Pull Request

Bug reports and pull requests are welcome on GitHub.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
