class DashboardsController < ApplicationController
   before_action :get_friends

   def index
      render("/dashboards/index.html.erb")
   end

   private
   def get_friends
      @friends = current_user.friends

      @friends.each do |friend|
         url = "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=#{ENV["STEAM_WEB_API_KEY"]}&steamids=#{friend.steam_uid}"
         parsed_data = JSON.parse(open(url).read)
         online_status = parsed_data["response"]["players"][0]["personastate"]
         if online_status > 0
            online_status = 1
         end

         in_game_status = parsed_data["response"]["players"][0]["gameid"]

         if in_game_status.nil?
            in_game_status = 0
            looking_to_play_status = 0
         else
            current_game = Library.find_by(:game_id => Game.find_by(:app_id => in_game_status).id, :owner_id => friend.id)

            p "****************************************"
            p in_game_status
            p friend.id
            p current_game
            p "****************************************"

            looking_to_play_status = current_game.default_looking_to_play_status
         end

         friend.online_status = online_status
         friend.in_game_status = in_game_status
         friend.looking_to_play_status = looking_to_play_status

         friend.save
      end

   end

end
