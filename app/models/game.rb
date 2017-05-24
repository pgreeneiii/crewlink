class Game < ApplicationRecord

   has_many(:libraries, :class_name => "Library", :foreign_key => "game_id", :dependent => :destroy)
   has_many(:gamers, :through => :libraries)
end
