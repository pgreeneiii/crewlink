class GamersController < ApplicationController
  def index
    @gamers = Gamer.all

    render("gamers/index.html.erb")
  end

  def show
    @gamer = Gamer.find(params[:id])

    render("gamers/show.html.erb")
  end

  def new
    @gamer = Gamer.new

    render("gamers/new.html.erb")
  end

  def create
    @gamer = Gamer.new

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
