class CreateFriends < ActiveRecord::Migration[5.0]
  def change
    create_table :friends do |t|
      t.integer :username_id
      t.integer :friend_id
      t.boolean :favorite_status
      t.boolean :approval_status

      t.timestamps

    end
  end
end
