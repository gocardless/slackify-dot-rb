class AddUser < ActiveRecord::Migration[5.2]
  def change
    enable_extension "pgcrypto"

    create_table :users, id: :uuid do |t|
      t.string :spotify_team_id
      t.string :spotify_user_id
      t.string :spotify_access_token
    end
  end
end
