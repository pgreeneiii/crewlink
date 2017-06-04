class FriendsController < ApplicationController
  def index
    @q = User.ransack(params[:q])

    render("friends/index.html.erb")
  end

  def find_friends
     @q = User.ransack(params[:q])
     @friends = @q.result

     render("friends/find_friends.html.erb")
  end

  def add_friend
     friend = User.find_by(:id => params[:id])
     if current_user.friend_request(friend)
        conversation = current_user.send_message(friend, params[:message][:body], params[:message][:subject]).conversation
        flash[:success] = "Friend request has been sent!"
     else
        flash[:alert] = "You have already sent this friend a request."
     end
     redirect_to(:back)
  end

  def remove_friend
     friend = User.find_by(:id => params[:id])
     if current_user.remove_friend(friend)
        flash[:alert] = "Friendship over."
     else
        flash[:alert] = "There was an error ending this friendship."
     end
     redirect_to(:back)
  end

  def show
    @friend = Friend.find(params[:id])

    render("friends/show.html.erb")
  end

  def new
    @friend = Friend.new

    render("friends/new.html.erb")
  end

  def create
    @friend = Friend.new

    @friend.username_id = params[:username_id]
    @friend.friend_id = params[:friend_id]
    @friend.favorite_status = params[:favorite_status]
    @friend.approval_status = params[:approval_status]

    save_status = @friend.save

    if save_status == true
      redirect_to("/friends/#{@friend.id}", :notice => "Friend created successfully.")
    else
      render("friends/new.html.erb")
    end
  end

  def edit
    @friend = Friend.find(params[:id])

    render("friends/edit.html.erb")
  end

  def update
    @friend = Friend.find(params[:id])

    @friend.username_id = params[:username_id]
    @friend.friend_id = params[:friend_id]
    @friend.favorite_status = params[:favorite_status]
    @friend.approval_status = params[:approval_status]

    save_status = @friend.save

    if save_status == true
      redirect_to("/friends/#{@friend.id}", :notice => "Friend updated successfully.")
    else
      render("friends/edit.html.erb")
    end
  end

  def destroy
    @friend = Friend.find(params[:id])

    @friend.destroy

    if URI(request.referer).path == "/friends/#{@friend.id}"
      redirect_to("/", :notice => "Friend deleted.")
    else
      redirect_to(:back, :notice => "Friend deleted.")
    end
  end
end
