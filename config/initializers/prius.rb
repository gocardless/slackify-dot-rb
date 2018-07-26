if Rails.env.development? || Rails.env.test?
  require "dotenv"
  Dotenv.load(Rails.root.join("config", "dummy-env"))
end

Prius.load(:slack_client_id)
Prius.load(:slack_client_secret)
Prius.load(:slack_redirect_uri)
Prius.load(:slack_team_id)
