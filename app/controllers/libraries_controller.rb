class LibrariesController < ApplicationController
  def index
    @libraries = Library.all

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
