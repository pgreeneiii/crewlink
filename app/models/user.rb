class User < ApplicationRecord
   # Include default devise modules. Others available are:
   # :confirmable, :lockable, :timeoutable and :omniauthable
   TEMP_EMAIL_PREFIX = 'change@me'
   TEMP_EMAIL_REGEX = /\Achange@me/

   devise :database_authenticatable, :registerable,
   :recoverable, :rememberable, :trackable, :validatable, :omniauthable

   validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

   has_many(:libraries, :class_name => "Library", :foreign_key => "owner_id", :dependent => :destroy)
   has_many(:requests, :class_name => "Request", :foreign_key => "uid")
   has_many(:pending_requests, :class_name => "Request", :foreign_key => "sender_id")
   has_many(:games, :through => :libraries)
   has_many :owned_games, :through => :libraries, :source => :game

   acts_as_messageable # integrates mailboxer gem features

   has_friendship # integrates has_friendship gem features

   def mailboxer_email(object)
      #return the model's email here
   end

   def self.find_for_oauth(auth, signed_in_resource = nil)

      # Get the identity and user if they exist
      identity = Identity.find_for_oauth(auth)

      # If a signed_in_resource is provided it always overrides the existing
      # user to prevent the identity being locked with accidentally created
      # accounts. Note that this may leave zombie accounts (with no associated
      # identity) which can be cleaned up at a later date.

      user = signed_in_resource ? signed_in_resource : identity.user

      # Create the user if needed
      if user.nil?

         # Get the existing user by email if the provider gives us a verified
         # email. If no verified email was provided, we assign a temporary
         # email and ask the user to verify the email on the next step
         # via UsersController.finish_signup
         email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
         email = auth.info.email if email_is_verified
         user = User.where(:email => email).first if email

         # Create the user if it's a new registration
         if user.nil?
            user = User.new(
            username: auth.info.nickname,
            steam_uid: auth.uid,
            email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.info.nickname}-#{auth.provider}.com",
            password: Devise.friendly_token[0,20]
            )
            #user.skip_confirmation!
            user.save!
         end
      end

      # Associate the identity with the user if needed
      if identity.user != user
         identity.user = user
         identity.save!
      end
      user
   end

   def email_verified?
      self.email && self.email !~ TEMP_EMAIL_REGEX
   end

   def refresh_library
      if self.steam_uid != nil #Steam_username has to exist to call API
         games = Steam::Player.owned_games(self.steam_uid)["games"]

         games.each do |game|
            if Game.where(:app_id => game["appid"]).exists?
               # Pull Game ID from database by Steam App ID
               game_id = Game.where(:app_id => game["appid"]).pluck(:id)[0]

               if self.libraries.find_by(:game_id => game_id).present? == false
                  # Pull multiplayer status from game database
                  multiplayer_status = Game.find_by(:id => game_id).multiplayer_status

                  # Build library entry
                  library = Library.new
                  library.owner_id = self.id
                  library.game_id = game_id
                  library.default_looking_to_play_status = multiplayer_status

                  library.save
               end
            else
               app_id = game["appid"].to_s
               url = "http://store.steampowered.com/api/appdetails?appids=#{app_id}"
               raw_data = open(url).read
               parsed_data = JSON.parse(raw_data)[app_id]
               success = parsed_data["success"]

               # Some App IDs no longer work (Steam has deleted data), so must test for success value of true
               if success == true
                  new_game = Game.new
                  app_id = game["appid"]
                  title = parsed_data["data"]["name"]
                  developer = parsed_data["data"]["developers"]
                  img_url = parsed_data["data"]["header_image"]
                  multiplayer_status = 0

                  categories = parsed_data["data"]["categories"]

                  if categories.class == Array

                     categories.each do |type|
                        if type["id"] == 1
                           multiplayer_status = 1
                        end
                     end
                  end

                  # Build game entry
                  new_game.app_id = app_id
                  new_game.title = title
                  new_game.developer = developer
                  new_game.multiplayer_status = multiplayer_status
                  new_game.img_url = img_url

                  new_game.save

                  # Build library entry
                  library = Library.new
                  library.owner_id = self.id
                  library.game_id = new_game.id
                  library.default_looking_to_play_status = new_game.multiplayer_status

                  library.save
               end
            end
         end
      else
         flash[:alert] = "You have not linked your Steam account."
      end
   end
end
