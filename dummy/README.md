# ACCC Dummy Application

This is a simple Sinatra application that demonstrates the usage of the ACCC gem for
authentication with Autodesk Construction Cloud API.

## Setup

1. Create a `.env` file in the dummy directory with your Autodesk APS credentials:

```env
CLIENT_ID=your_client_id
CLIENT_SECRET=your_client_secret
```

2. Install dependencies:

```bash
bundle install
```

3. Run the application:

```bash
bundle exec rackup -p 3000
```

The application will be available at http://localhost:3000

## Features

### Authentication Flow

1. Visit the home page (http://localhost:3000)
2. Click "Login with Autodesk" to start the OAuth flow
3. You'll be redirected to Autodesk's login page
4. After successful authentication, you'll be redirected back to the application

### Token Management

Once authenticated, you can:

- View your current access and refresh tokens
- Refresh your tokens using the "Refresh Tokens" link
- Logout to clear your session

### Error Handling

The application demonstrates proper error handling for various scenarios:

- Invalid authorization codes
- Expired tokens
- Failed token refresh attempts

## Testing Different Scenarios

### Testing Token Refresh

1. Login to get initial tokens
2. Wait for the access token to expire (typically 1 hour)
3. Try to refresh tokens using the "Refresh Tokens" link

### Testing Error Handling

- Modify your client credentials in `.env` to test authentication failures
- Clear your session cookies to test re-authentication
- Try refreshing with an invalid refresh token

## Configuration

The application is configured with these default settings:

- Callback URL: http://localhost:3000/autodesk/callback
- Scope: data:read

To modify these settings, edit the `config.ru` file.

## Endpoints

- `GET /` - Home page, shows login link or current tokens
- `GET /auth` - Initiates the OAuth flow
- `GET /autodesk/callback` - OAuth callback handler
- `GET /refresh` - Refreshes the current tokens
- `GET /logout` - Clears the session

## Security Notes

This is a demonstration application and includes features that might not be
suitable for production use:

- Tokens are stored in the session
- Error messages might be too verbose
- No CSRF protection
- No secure cookie configuration 