class SlackOauthController < ApplicationController
  def begin
    slack_url = "https://slack.com/oauth/authorize?" \
      "client_id=#{Prius.get(:slack_client_id)}&" \
      "scope=#{URI.escape("users.profile:write")}&" \
      "redirect_uri=#{URI.escape(Prius.get(:slack_redirect_uri))}&" \
      "team=#{Prius.get(:slack_team_id)}"

    redirect_to slack_url
  end

  def redirect
    response = slack_client.oauth_access(
      client_id: Prius.get(:slack_client_id),
      client_secret: Prius.get(:slack_client_secret),
      redirect_uri: Prius.get(:slack_redirect_uri),
      code: params[:code],
    )

    user = User.find_or_create_by(
      slack_team_id: response["team_id"],
      slack_user_id: response["user_id"],
    )

    user.update!(slack_access_token: response["access_token"])

    session[:current_user_id] = user.id

    redirect_to :root
  end

  private

  def slack_client
    @client ||= Slack::Web::Client.new
  end
end
