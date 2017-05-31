class GamesController < ApplicationController

   def refresh
      games = Game.all
      # Will use counters to provide info about results to user
      refresh_count = 0
      refresh_error = 0

      games.each do |game|
         # Checks if any hash in game is empty
         if game.needs_refresh?
            url = "http://store.steampowered.com/api/appdetails?appids=#{game.app_id}"
            raw_data = open(url).read
            parsed_data = JSON.parse(raw_data)[game.app_id.to_s]
            success = parsed_data["success"]

            if success == true
               game.title = parsed_data["data"]["name"]
               game.developer = parsed_data["data"]["developers"]
               game.img_url = parsed_data["data"]["header_image"]
               multiplayer_status = 0

               categories = parsed_data["data"]["categories"]

               if categories.class == Array

                  categories.each do |type|
                     if type["id"] == 1
                        multiplayer_status = 1
                     end
                  end
               end

               game.multiplayer_status = multiplayer_status
               game.save

               if game.needs_refresh?
                  refresh_error = refresh_error + 1
               else
                  refresh_count = refresh_count + 1
               end
            end
         end
      end

      if refresh_count == 0 && refresh_error == 0
         flash[:alert] = "All games already up-to-date"
      elsif refresh_count == 1
         flash[:notice] = "#{refresh_count} game has been updated"
         if refresh_error == 1
            flash[:alert] = "#{refresh_error} game could not be updated"
         elsif refresh_error > 1
            flash[:alert] = "#{refresh_error} games could not be updated"
         end
      elsif refresh_count > 1
         flash[:notice] = "#{refresh_count} games have been updated"
         if refresh_error == 1
            flash[:alert] = "#{refresh_error} game could not be updated"
         elsif refresh_error > 1
            flash[:alert] = "#{refresh_error} games could not be updated"
         end
      end
      redirect_back(fallback_location: root_path)
   end

   def index
      @games = Game.all

      render("games/index.html.erb")
   end

   def show
      @game = Game.find(params[:id])

      url="http://store.steampowered.com/api/appdetails?appids=#{@appID}"

      render("games/show.html.erb")
   end

   def new
      @game = Game.new

      render("games/new.html.erb")
   end

   def create
      @game = Game.new

      @game.title = params[:title]
      @game.developer = params[:developer]
      @game.multiplayer_status = params[:multiplayer_status]

      save_status = @game.save

      if save_status == true
         redirect_to("/games/#{@game.id}", :notice => "Game created successfully.")
      else
         render("games/new.html.erb")
      end
   end

   def edit
      @game = Game.find(params[:id])

      render("games/edit.html.erb")
   end

   def update
      @game = Game.find(params[:id])

      @game.title = params[:title]
      @game.developer = params[:developer]
      @game.multiplayer_status = params[:multiplayer_status]

      save_status = @game.save

      if save_status == true
         redirect_to("/games/#{@game.id}", :notice => "Game updated successfully.")
      else
         render("games/edit.html.erb")
      end
   end

   def destroy
      @game = Game.find(params[:id])

      @game.destroy

      if URI(request.referer).path == "/games/#{@game.id}"
         redirect_to("/", :notice => "Game deleted.")
      else
         redirect_to(:back, :notice => "Game deleted.")
      end
   end
end
