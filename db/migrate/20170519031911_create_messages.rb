class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.integer :recipient_id
      t.integer :sender_id
      t.text :message
      t.boolean :read_status

      t.timestamps

    end
  end
end
