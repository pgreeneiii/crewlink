class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

   validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

   has_many(:libraries, :class_name => "Library", :foreign_key => "owner_id", :dependent => :destroy)
   has_many(:games, :through => :libraries)
   has_many :owned_games, :through => :libraries, :source => :game

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


# Class ReadDataFromApiJob
#   def read_from_api
#      users = User.all
#      user.each do |user|
#         url = "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=#{ENV["STEAM_WEB_API_KEY"]}&steamids=#{user.steam_uid}"
#         parsed_data = JSON.parse(open(url).read)
#         online_status = parsed_data["response"]["players"][0]["personastate"]
#         if online_status > 0
#            online_status = 1
#         end
#
#         in_game_status = parsed_data["response"]["players"][0]["gameid"]
#
#         if in_game_status.nil?
#            in_game_status = 0
#         end
#
#         user.online_status = online_status
#         user.in_game_status = in_game_status
#
#         user.save
#      end
#   end
# end

end
