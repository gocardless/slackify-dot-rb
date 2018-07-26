require "excon"

class SpotifyOauthController < ApplicationController
  def begin
    spotify_url = "https://accounts.spotify.com/authorize?" \
      "client_id=#{Prius.get(:spotify_client_id)}&" \
      "response_type=code&" \
      "redirect_uri=#{URI.escape(Prius.get(:spotify_redirect_uri))}&" \
      "scope=#{URI.escape("user-read-currently-playing")}&" \

    redirect_to spotify_url
  end

  def redirect
    user = User.find(session[:current_user_id])

    tokens = Excon.post(
      "https://accounts.spotify.com",
      path: "/api/token",
      headers: { "Content-Type" => "application/x-www-form-urlencoded" },
      body: URI.encode_www_form(
        grant_type: "authorization_code",
        code: params[:code],
        redirect_uri: Prius.get(:spotify_redirect_uri),
      ),
      user: Prius.get(:spotify_client_id),
      password: Prius.get(:spotify_client_secret),
    )

    user.update!(spotify_refresh_token: JSON.parse(tokens.body)["refresh_token"])

    redirect_to :root
  end
end
