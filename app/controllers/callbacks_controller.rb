class CallbacksController < Devise::OmniauthCallbacksController
   skip_before_filter :verify_authenticity_token
   
   # def auth_callback
   #    auth = request.env['omniauth.auth']
   #    session[:current_user] = { nickname: auth[:info][:nickname], image: auth[:info][:image], uid: auth[:uid], name: auth[:info][:name] }
   #
   #    @gamer = Gamer.new
   #    @steam_username = session[:current_user][:nickname]
   #
   #    p "****************************************"
   #    p session[:current_user]
   #    p @steam_username
   #    p "****************************************"
   #
   # end

   def steam
      @user = User.from_omniauth(request.env["omniauth.auth"])

      p "****************************************"
      p @user
      p "****************************************"

      sign_in_and_redirect @user
   end
end
