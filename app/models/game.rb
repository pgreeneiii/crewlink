class Game < ApplicationRecord

   has_many(:libraries, :class_name => "Library", :foreign_key => "game_id", :dependent => :destroy)
   has_many(:gamers, :through => :libraries)
   belongs_to(:player, :class_name => "User", :foreign_key => "in_game_status")

   # def needs_refresh?
   #    value = false
   #    if self.app_id.present?
   #       if self.id.present? == false
   #          value = true
   #       end
   #
   #       if self.title.present? == false
   #          value = true
   #       end
   #
   #       if self.developer.present? == false
   #          value = true
   #       end
   #
   #       if self.multiplayer_status.present? == false
   #          value = true
   #       end
   #
   #       if self.img_url.present? == false
   #          value = true
   #       end
   #    end
   #
   #    value
   # end

end
