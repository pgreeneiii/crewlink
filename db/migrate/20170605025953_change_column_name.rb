class ChangeColumnName < ActiveRecord::Migration[5.0]
  def change
     rename_column :requests, :sender, :sender_id
  end
end
