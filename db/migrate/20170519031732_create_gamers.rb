class CreateGamers < ActiveRecord::Migration[5.0]
  def change
    create_table :gamers do |t|
      t.string :email
      t.string :username
      t.string :password
      t.string :steam_username
      t.string :first_name
      t.string :last_name
      t.string :profile_img
      t.integer :last_played_game
      t.boolean :online_status
      t.integer :in_game_status
      t.boolean :looking_to_play_status

      t.timestamps

    end
  end
end
