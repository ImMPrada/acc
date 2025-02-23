# Authentication

The authentication process with Autodesk Construction Cloud API uses OAuth 2.0 with
a 3-legged flow. This means the authentication requires user interaction to grant
access to the application.

## Configuration

First, configure your application with the credentials from Autodesk APS:

```ruby
ACCC.configure do |config|
  config.client_id = 'your_client_id'
  config.client_secret = 'your_client_secret'
  config.callback_url = 'your_callback_url'  # Must match APS registration
  config.scope = 'data:read'  # Add required scopes
end
```

## Authentication Flow

### 1. Get Authorization URL

Generate the URL where users will be redirected to authorize your application:

```ruby
auth = ACCC::Endpoints::Auth.new
authorization_url = auth.authorization_url
# Redirect user to this URL
```

### 2. Handle Callback

After the user authorizes your application, they will be redirected back to your
`callback_url` with an authorization code. Exchange this code for access and
refresh tokens:

```ruby
auth = ACCC::Endpoints::Auth.new
begin
  tokens = auth.exchange_code(params[:code])
  access_token = tokens['access_token']
  refresh_token = tokens['refresh_token']
rescue ACCC::Errors::AccessTokenExpiredError
  # Handle expired access token
rescue ACCC::Errors::RefreshTokenExpiredError
  # Handle expired refresh token, redirect to re-auth
rescue ACCC::Errors::Error => e
  # Handle other authentication errors
end
```

## Available Scopes

Common scopes include:

* `data:read` - Read access to BIM 360 data
* `data:write` - Write access to BIM 360 data
* `data:create` - Create new items in BIM 360
* `data:search` - Search capabilities in BIM 360
* `account:read` - Read access to account information
* `account:write` - Write access to account information

## Error Handling

The authentication process can raise several types of errors:

* `ACCC::Errors::AccessTokenExpiredError` - When the access token has expired
* `ACCC::Errors::RefreshTokenExpiredError` - When the refresh token has expired
* `ACCC::Errors::Error` - Base error class for other authentication errors

## Example Implementation

See the dummy application in `/dummy` for a complete working example of the
authentication flow.
