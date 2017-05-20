class AddAppIdToGames < ActiveRecord::Migration[5.0]
  def change
     add_column :games, :app_id, :integer
  end
end
