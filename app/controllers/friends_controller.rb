class FriendsController < ApplicationController

  def index

     @friends = current_user.friends
    render("friends/index.html.erb")
  end

  def find_friends
     @friends = @q.result

     render("friends/find_friends.html.erb")
  end

  def make_preferred
     preferred_friend = PreferredFriend.new
     preferred_friend.user_id = current_user.id
     preferred_friend.friend_id = params[:id]

     preferred_friend.save

     redirect_back(fallback_location: root_path)

  end

  def end_preferred
     preferred_friend = PreferredFriend.find_by(:user_id => current_user.id, :friend_id => params[:id])

     preferred_friend.destroy

     redirect_back(fallback_location: root_path)

  end

end
