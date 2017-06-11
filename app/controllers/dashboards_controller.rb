class DashboardsController < ApplicationController
   before_action :get_friends

   def index

      render("/dashboards/index.html.erb")
   end

   def change_status
      user = current_user

      # Toggle returns nil if user sets to false, so controller sets nil to false
      if params[:looking_to_play_status].nil?
         params[:looking_to_play_status] = false
      end

      # Set new looking_to_play_status
      user.looking_to_play_status = params[:looking_to_play_status]

      # Want to over-ride auto-updates on current game's default looking to play status, so set current game's default_looking_to_play_status to whatever looking_to_play_status user has selected
      if (current_user.in_game_status != nil && current_user.in_game_status > 0)
         library = Library.find_by(:owner_id => current_user.id, :game_id => params[:game_id])

         library.default_looking_to_play_status = params[:looking_to_play_status]

         library.save
      end

      # save user entry
      user.save

      head :no_content
   end

   private
   def get_friends
      @friends = current_user.preferred_friends.order('online_status DESC', :username)

   end

end
