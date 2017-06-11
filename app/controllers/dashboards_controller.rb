class DashboardsController < ApplicationController
   before_action :get_friends

   def index

      render("/dashboards/index.html.erb")
   end

   def change_status
      user = current_user

      if params[:looking_to_play_status].nil?
         params[:looking_to_play_status] = false
      end

      user.looking_to_play_status = params[:looking_to_play_status]

      if (current_user.in_game_status != nil && current_user.in_game_status > 0)
         library = Library.find_by(:owner_id => current_user.id, :game_id => params[:game_id])

         library.default_looking_to_play_status = params[:looking_to_play_status]

         library.save
      end

      user.save

      head :no_content
   end


   private
   def get_friends
      @friends = current_user.preferred_friends

   end

end
