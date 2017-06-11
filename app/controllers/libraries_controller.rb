class LibrariesController < ApplicationController

   def load
      if current_user.refresh_library
         flash[:notice] = "Your library is up to date."
      else
         flash[:alert] = "Cannot load library. Please ensure your Steam account is public."
      end
      redirect_back(fallback_location: root_path)
   end


   def index
      @libraries = current_user.libraries

      render("libraries/index.html.erb")
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

   def update
      @library = Library.find(params[:id])

      @library.owner_id = params[:owner_id]
      @library.game_id = params[:game_id]

      if params[:default_looking_to_play_status].nil?
            params[:default_looking_to_play_status] = false
      end

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
      else
         head :no_content
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
