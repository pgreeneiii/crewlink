class UpdateUserDatabaseJob < ApplicationJob
  queue_as :default

  def perform
     users = User.all

     users.each do |user|
        url = "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=#{ENV["STEAM_WEB_API_KEY"]}&steamids=#{user.steam_uid}"
        parsed_data = JSON.parse(open(url).read)
        online_status = parsed_data["response"]["players"][0]["personastate"]



        if online_status > 0
           online_status = 1

           in_game_status = parsed_data["response"]["players"][0]["gameid"]

           if in_game_status.nil?
             in_game_status = 0
             looking_to_play_status = 0
           else
             # Set Looking to play status based on game
              current_game = user.owned_games.find_by(:app_id =>  in_game_status)
              looking_to_play_status = user.libraries.find_by(:game_id => current_game.id).default_looking_to_play_status
           end
        else
           in_game_status = 0
           looking_to_play_status = 0
        end

        if user.in_game_status != 0 && in_game_status == 0
           user.last_played_game = user.in_game_status
        end

        user.online_status = online_status
        user.in_game_status = in_game_status
        user.looking_to_play_status = looking_to_play_status
        user.save
     end
  end
end
