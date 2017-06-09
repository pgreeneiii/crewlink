class ApplicationController < ActionController::Base
   protect_from_forgery with: :exception
   before_action :authenticate_user!
   before_action :ensure_signup_complete
   before_action :set_ransack
   before_action :configure_permitted_parameters, if: :devise_controller?

   def ensure_signup_complete
      # Ensure we don't go into an infinite loop
      return if action_name == 'finish_signup'

      # Redirect to the 'finish_signup' page if the user
      # email hasn't been verified yet
      if current_user && !current_user.email_verified?
         redirect_to finish_signup_path(current_user)
      end
   end

   rescue_from ActiveRecord::RecordNotFound do
      flash[:warning] = 'Resource not found.'
      redirect_back_or root_path
   end

   def redirect_back_or(path)
      redirect_to request.referer || path
   end

   private
   def set_ransack
      @q = User.ransack(params[:q])
   end

   protected
   def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, :keys => [:username, :first_name, :last_name])

      devise_parameter_sanitizer.permit(:account_update, :keys => [:username, :first_name, :last_name])
   end
end
