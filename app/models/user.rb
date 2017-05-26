class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

   def self.from_omniauth
      where(steam_uid: auth.uid).first_or_create do |user|
         user.username = auth.info.nickname
         user.password = Devise.friendly_token[0,20]
      end
   end
end
