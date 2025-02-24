# Resources Documentation

## Authentication

The authentication process with Autodesk Construction Cloud API uses OAuth 2.0 with
a 3-legged flow. This means the authentication requires user interaction to grant
access to the application.

### Configuration

First, configure your application with the credentials from Autodesk APS:

```ruby
ACC.configure do |config|
  config.client_id = 'your_client_id'
  config.client_secret = 'your_client_secret'
  config.callback_url = 'your_callback_url'  # Must match APS registration
  config.scope = 'data:read'  # Add required scopes
end
```

### Authentication Flow

#### 1. Get Authorization URL

Generate the URL where users will be redirected to authorize your application:

```ruby
auth = ACC::Endpoints::Auth.new
authorization_url = auth.authorization_url
# Redirect user to this URL
```

#### 2. Handle Callback

After the user authorizes your application, they will be redirected back to your
`callback_url` with an authorization code. Exchange this code for access and
refresh tokens:

```ruby
auth = ACC::Endpoints::Auth.new
begin
  tokens = auth.exchange_code(params[:code])
  access_token = tokens['access_token']
  refresh_token = tokens['refresh_token']
rescue ACC::Errors::AccessTokenExpiredError
  # Handle expired access token
rescue ACC::Errors::RefreshTokenExpiredError
  # Handle expired refresh token, redirect to re-auth
rescue ACC::Errors::Error => e
  # Handle other authentication errors
end
```

### Available Scopes

Common scopes include:

- `data:read` - Read access to BIM 360 data
- `data:write` - Write access to BIM 360 data
- `data:create` - Create new items in BIM 360
- `data:search` - Search capabilities in BIM 360
- `account:read` - Read access to account information
- `account:write` - Write access to account information

### Error Handling

The authentication process can raise several types of errors:

- `ACC::Errors::AccessTokenExpiredError` - When the access token has expired
- `ACC::Errors::RefreshTokenExpiredError` - When the refresh token has expired
- `ACC::Errors::Error` - Base error class for other authentication errors

### Example Implementation

See the dummy application in `/dummy` for a complete working example of the
authentication flow.

## API Resources

### Construction Cloud

#### Issues API

The Issues API allows you to interact with issues in your Autodesk Construction
Cloud projects.

##### Issue Operations

The `Issues::Index` class provides methods to list and query issues from a project.

###### Basic Usage

```ruby
# Initialize with an authenticated client
auth = ACC::Resources::Auth.new(access_token: your_access_token)
issues = ACC::Resources::ConstructionCloud::Issues::Index.new(auth, project_id)

# Get all issues (handles pagination automatically)
all_issues = issues.all_paginated

# Process the issues
all_issues.each do |issue|
  puts "ID: #{issue['id']}"
  puts "Title: #{issue['title']}"
  puts "Status: #{issue['status']}"
  puts "Created At: #{issue['createdAt']}"
end
```

###### Available Methods

- `all_paginated` - Returns all issues, handling pagination automatically
- `find(issue_id)` - Returns a specific issue by ID
- `where(params)` - Returns issues matching the given criteria

###### Filtering Issues

You can filter issues using the `where` method:

```ruby
# Filter by status
open_issues = issues.where(status: 'open')

# Filter by creation date
recent_issues = issues.where(
  created_after: '2024-01-01',
  created_before: '2024-03-21'
)

# Filter by multiple criteria
critical_open_issues = issues.where(
  status: 'open',
  priority: 'high',
  type: 'defect'
)
```

###### Pagination

By default, `all_paginated` handles pagination automatically. If you need more
control:

```ruby
# Get specific page
page_2 = issues.where(page: 2, per_page: 50)

# Get all issues with custom page size
all_issues = issues.all_paginated(per_page: 100)
```

###### Issue Error Handling

```ruby
begin
  issues = issues_client.all_paginated
rescue ACC::Errors::AccessTokenError
  # Handle expired access token
rescue ACC::Errors::AuthError => e
  # Handle other authentication errors
rescue ACC::Errors::APIError => e
  # Handle API errors (rate limits, server errors, etc.)
end
```

For more details about the Issues API endpoints and response formats, see the
[Issues API Reference].

[Issues API Reference]: https://aps.autodesk.com/en/docs/acc/v1/reference/http/issues-issues-GET/