Rails.application.routes.draw do
  root "welcome#index"
  get "/slack/oauth/begin", to: "slack_oauth#begin"
  get "/slack/oauth/redirect", to: "slack_oauth#redirect"

  get "/spotify/oauth/begin", to: "spotify_oauth#begin"
  get "/spotify/oauth/redirect", to: "spotify_oauth#redirect"
end
