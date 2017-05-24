class Library < ApplicationRecord

   belongs_to(:game, :class_name => "Game", :foreign_key => "game_id")
   belongs_to(:gamer, :class_name => "Gamer", :foreign_key => "owner_id")
end
