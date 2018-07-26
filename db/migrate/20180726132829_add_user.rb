class AddUser < ActiveRecord::Migration[5.2]
  def change
    enable_extension "pgcrypto"

    create_table :users, id: :uuid do |t|
      t.string :slack_team_id
      t.string :slack_user_id
      t.string :slack_access_token

      t.string :spotify_refresh_token
    end
  end
end
