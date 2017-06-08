class DashboardsController < ApplicationController
   before_action :get_friends

   def index
      
      render("/dashboards/index.html.erb")
   end


   private
   def get_friends
      @friends = current_user.friends

   end

end
