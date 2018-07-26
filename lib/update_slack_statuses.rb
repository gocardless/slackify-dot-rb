class UpdateSlackStatuses
  def run
    User.find_each do |user|
      response = Excon.post(
        "https://accounts.spotify.com",
        path: "/api/token",
        headers: { "Content-Type" => "application/x-www-form-urlencoded" },
        body: URI.encode_www_form(
          grant_type: "refresh_token",
          refresh_token: user.spotify_refresh_token,
        ),
        user: Prius.get(:spotify_client_id),
        password: Prius.get(:spotify_client_secret),
      )

      parsed = JSON.parse(response.body)
      access_token = parsed["access_token"]

      now_playing_response = Excon.get(
        "https://api.spotify.com",
        path: "/v1/me/player/currently-playing",
        headers: { "Authorization" => "Bearer #{access_token}" },
      )

      now_playing_parsed = JSON.parse(now_playing_response.body)
      # puts JSON.pretty_generate(now_playing_parsed)

      artist = now_playing_parsed["item"]["artists"].first["name"]
      track = now_playing_parsed["item"]["name"]
      now_playing = "#{artist} - #{track}"

      response = Excon.post(
        "https://slack.com",
        path: "/api/users.profile.set",
        headers: { "Content-Type" => "application/x-www-form-urlencoded" },
        body: URI.encode_www_form(
          token: user.slack_access_token,
          profile: JSON.generate(
            {
              "status_text": now_playing,
              "status_emoji": ":musical_note:",
            }
          ),
        ),
      )

      puts "updated"
    end
  end
end
