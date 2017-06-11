class UpdateUserDatabaseJob < ApplicationJob
  queue_as :default

  # Runs through every user in database and updates their online and in-game status from Steam
  def perform
     users = User.all

     users.each do |user|

        # Pull User status using Steam API
        url = "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=#{ENV["STEAM_WEB_API_KEY"]}&steamids=#{user.steam_uid}"
        parsed_data = JSON.parse(open(url).read)
        online_status = parsed_data["response"]["players"][0]["personastate"]


        # Steam has many different status types, but anything above zero is indicative of the User having Steam open and being sign-in on at least one device
        if online_status > 0
           online_status = 1

           in_game_status = parsed_data["response"]["players"][0]["gameid"]

           # If user is not in-game, in_game_status will be nil
           if in_game_status.nil?
             in_game_status = 0
             looking_to_play_status = 0
           else
             # Set Looking to play status based on game (Steamm returns app_id number when player is playing a game)
              current_game = user.owned_games.find_by(:app_id =>  in_game_status)
              looking_to_play_status = user.libraries.find_by(:game_id => current_game.id).default_looking_to_play_status
           end
        #If offline, player cannot be in a game and is not looking to play
        else
           in_game_status = 0
           looking_to_play_status = 0
        end

        # Store the user's last played game if they have played a game and this has been previously recorded in our database
        if user.in_game_status != 0 && in_game_status == 0
           user.last_played_game = user.in_game_status
        end

        #Update user entry
        user.online_status = online_status
        user.in_game_status = in_game_status
        user.looking_to_play_status = looking_to_play_status
        user.save
     end
  end
end
