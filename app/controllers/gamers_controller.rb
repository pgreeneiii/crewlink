class GamersController < ApplicationController
  def index
    @gamers = Gamer.all

    render("gamers/index.html.erb")
  end

  def show
    @gamer = Gamer.find(params[:id])
    Steam.apikey = ENV["steam_api_key"]
    steam_id = Steam::User.vanity_to_steamid(@gamer.steam_username)

    @games = Steam::Player.owned_games(steam_id)["games"]



    render("gamers/show.html.erb")
  end

  def new
    @gamer = Gamer.new

    render("gamers/new.html.erb")
  end

  def create
    @gamer = Gamer.new
    Steam.apikey = ENV["steam_api_key"]

    @gamer.email = params[:email]
    @gamer.username = params[:username]
    @gamer.password = params[:password]
    @gamer.steam_username = params[:steam_username]
    @gamer.first_name = params[:first_name]
    @gamer.last_name = params[:last_name]
    @gamer.profile_img = params[:profile_img]
    @gamer.last_played_game = params[:last_played_game]
    @gamer.online_status = params[:online_status]
    @gamer.in_game_status = params[:in_game_status]
    @gamer.looking_to_play_status = params[:looking_to_play_status]

    save_status = @gamer.save

    if save_status == true
      if @gamer.steam_username != nil
         steam_id = Steam::User.vanity_to_steamid(@gamer.steam_username)
         games = Steam::Player.owned_games(steam_id)["games"]

         games.each do |appID|

            if Game.where(:app_id => appID["appid"]).exists? == false
               game_num = appID["appid"].to_s
               url = "http://store.steampowered.com/api/appdetails?appids=#{game_num}"
               raw_data = open(url).read
               parsed_data = JSON.parse(raw_data)[game_num]
               success = parsed_data["success"]

               if success == true
                  game = Game.new
                  app_id = appID["appid"]
                  title = parsed_data["data"]["name"]
                  developer = parsed_data["data"]["developers"]
                  multiplayer_status = 0

                  categories = parsed_data["data"]["categories"]

                  if categories.class == Array

                     categories.each do |type|
                        if type["id"] == 1
                           multiplayer_status = 1
                        end
                     end
                  end

                  game.app_id = app_id
                  game.title = title
                  game.developer = developer
                  game.multiplayer_status = multiplayer_status
                  game.save

                  library = Library.new
                  library.owner_id = @gamer.id
                  library.game_id = game.id
                  library.default_looking_to_play_status = game.multiplayer_status

                  library.save
               end

            else
               game_id = Game.where(:app_id => appID["appid"]).pluck(:id)[0]
               multiplayer_status = Game.where(:app_id => appID["appid"]).pluck(:multiplayer_status)[0]
               library = Library.new
               library.owner_id = @gamer.id
               library.game_id = game_id
               library.default_looking_to_play_status = multiplayer_status

               library.save
            end
         end
      end

      redirect_to("/gamers/#{@gamer.id}", :notice => "Gamer created successfully.")
    else
      render("gamers/new.html.erb")
    end
  end

  def edit
    @gamer = Gamer.find(params[:id])

    render("gamers/edit.html.erb")
  end

  def update
    @gamer = Gamer.find(params[:id])

    @gamer.email = params[:email]
    @gamer.username = params[:username]
    @gamer.password = params[:password]
    @gamer.steam_username = params[:steam_username]
    @gamer.first_name = params[:first_name]
    @gamer.last_name = params[:last_name]
    @gamer.profile_img = params[:profile_img]
    @gamer.last_played_game = params[:last_played_game]
    @gamer.online_status = params[:online_status]
    @gamer.in_game_status = params[:in_game_status]
    @gamer.looking_to_play_status = params[:looking_to_play_status]

    save_status = @gamer.save

    if save_status == true
      redirect_to("/gamers/#{@gamer.id}", :notice => "Gamer updated successfully.")
    else
      render("gamers/edit.html.erb")
    end
  end

  def destroy
    @gamer = Gamer.find(params[:id])

    @gamer.destroy

    if URI(request.referer).path == "/gamers/#{@gamer.id}"
      redirect_to("/", :notice => "Gamer deleted.")
    else
      redirect_to(:back, :notice => "Gamer deleted.")
    end
  end
end
