class CreateLibraries < ActiveRecord::Migration[5.0]
  def change
    create_table :libraries do |t|
      t.integer :owner_id
      t.integer :game_id
      t.boolean :default_looking_to_play_status

      t.timestamps

    end
  end
end
