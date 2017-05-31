class Gamer < ApplicationRecord
   validates :steam_username, :presence => true, :uniqueness => true

   has_many(:libraries, :class_name => "Library", :foreign_key => "owner_id", :dependent => :destroy)
   has_many(:games, :through => :libraries)

   has_many(:messages, :class_name => "Message", :foreign_key => "recipient_id")
   has_many(:sent_messages, :class_name => "Message", :foreign_key => "sender_id")

   has_many(:friends, :class_name => "Friend", :foreign_key => "username_id")

end
