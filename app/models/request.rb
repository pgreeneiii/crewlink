class Request < ApplicationRecord
   belongs_to(:recipient, :class_name => "User", :foreign_key => "uid")
   belongs_to(:sender, :class_name => "User", :foreign_key => "sender_id")
end
