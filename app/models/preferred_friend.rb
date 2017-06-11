class PreferredFriend < ApplicationRecord
   belongs_to(:preferer, :class_name => "User", :foreign_key => "user_id")
   belongs_to(:preferred, :class_name => "User", :foreign_key => "friend_id")
end
