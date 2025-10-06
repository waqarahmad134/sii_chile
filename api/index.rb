# frozen_string_literal: true

require_relative "../gem/lib/sii_chile"

# Vercel Ruby serverless entry for root path
# Redirects to the GitHub repo, matching original Sinatra '/' behavior

def handler(event:, context:)
  {
    statusCode: 302,
    headers: {
      "Location" => "https://github.com/sagmor/sii_chile"
    },
    body: ""
  }
end
