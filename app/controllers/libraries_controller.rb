class LibrariesController < ApplicationController

   def load
      if current_user.steam_uid != nil #Steam_username has to exist to call API
         # Converts steam username to 64-digit id number
         steam_id = current_user.steam_uid

         # Calls user's owned games by Steam App ID
         games = Steam::Player.owned_games(steam_id)["games"]

         games.each do |appID|
            # Only adds game to library if game already doesn't exist
            if Game.where(:app_id => appID["appid"]).exists? == false
               game_num = appID["appid"].to_s
               url = "http://store.steampowered.com/api/appdetails?appids=#{game_num}"
               raw_data = open(url).read
               parsed_data = JSON.parse(raw_data)[game_num]
               success = parsed_data["success"]

               # Some App IDs no longer work (Steam has deleted data), so must test for success value of true
               if success == true
                  game = Game.new
                  app_id = appID["appid"]
                  title = parsed_data["data"]["name"]
                  developer = parsed_data["data"]["developers"]
                  img_url = parsed_data["data"]["header_image"]
                  multiplayer_status = 0

                  categories = parsed_data["data"]["categories"]

                  if categories.class == Array

                     categories.each do |type|
                        if type["id"] == 1
                           multiplayer_status = 1
                        end
                     end
                  end

                  # Build game entry
                  game.app_id = app_id
                  game.title = title
                  game.developer = developer
                  game.multiplayer_status = multiplayer_status
                  game.save

                  # Build library entry
                  library = Library.new
                  library.owner_id = current_user.id
                  library.game_id = game.id
                  library.default_looking_to_play_status = game.multiplayer_status

                  library.save
               end

               # Game already exists, in database - skip to building library
            else
               # Pull Game ID from database by Steam App ID
               game_id = Game.where(:app_id => appID["appid"]).pluck(:id)[0]
               # Pull multiplayer status from game database
               multiplayer_status = Game.find_by(:id => game_id).multiplayer_status

               # Build library entry
               library = Library.new
               library.owner_id = current_user.id
               library.game_id = game_id
               library.default_looking_to_play_status = multiplayer_status

               library.save
            end
         end
         flash[:notice] = "Your library is up to date."
          redirect_back(fallback_location: root_path)
      else
         flash[:alert] = "You have not linked your Steam account."
      end
   end


   def index
      @libraries = current_user.libraries

      render("libraries/index.html.erb")
   end

   def show
      @library = Library.find(params[:id])

      render("libraries/show.html.erb")
   end

   def new
      @library = Library.new

      render("libraries/new.html.erb")
   end

   def create
      @library = Library.new

      @library.owner_id = params[:owner_id]
      @library.game_id = params[:game_id]
      @library.default_looking_to_play_status = params[:default_looking_to_play_status]

      save_status = @library.save

      if save_status == true
         redirect_to("/libraries/#{@library.id}", :notice => "Library created successfully.")
      else
         render("libraries/new.html.erb")
      end
   end

   def edit
      @library = Library.find(params[:id])

      render("libraries/edit.html.erb")
   end

   def update
      @library = Library.find(params[:id])

      @library.owner_id = params[:owner_id]
      @library.game_id = params[:game_id]
      @library.default_looking_to_play_status = params[:default_looking_to_play_status]

      save_status = @library.save

      if save_status == true
         redirect_to("/libraries/#{@library.id}", :notice => "Library updated successfully.")
      else
         render("libraries/edit.html.erb")
      end
   end

   def toggle
      @library = Library.find(params[:id])

      @library.owner_id = params[:owner_id]
      @library.game_id = params[:game_id]

      if params[:default_looking_to_play_status].nil?
         params[:default_looking_to_play_status] = false
      end

      @library.default_looking_to_play_status = params[:default_looking_to_play_status]

      save_status = @library.save

      if save_status == false
         render("libraries/edit.html.erb")
      end
   end


   def destroy
      @library = Library.find(params[:id])

      @library.destroy

      if URI(request.referer).path == "/libraries/#{@library.id}"
         redirect_to("/", :notice => "Library deleted.")
      else
         redirect_to(:back, :notice => "Library deleted.")
      end
   end
end
