class CreateRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :requests do |t|
      t.integer :uid
      t.integer :sender

      t.timestamps
    end
  end
end
