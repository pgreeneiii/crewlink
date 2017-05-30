class WelcomeController < ApplicationController
   # auth callback POST comes from Steam so we can't attach CSRF token
   skip_before_action :verify_authenticity_token, :only => :auth_callback

   def auth_callback
      auth = request.env['omniauth.auth']
      session[:current_user] = { nickname: auth[:info][:nickname], image: auth[:info][:image], uid: auth[:uid], name: auth[:info][:name] }

      @gamer = Gamer.new
      @steam_username = session["current_user"]["nickname"]
      render("/gamers/new")

      p "****************************************"
      p session[:current_user]
      p "****************************************"
   end

   def index
   end


end
