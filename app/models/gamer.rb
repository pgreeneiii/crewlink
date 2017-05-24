class Gamer < ApplicationRecord
   validates :steam_username, :presence => true, :uniqueness => true

   
end
