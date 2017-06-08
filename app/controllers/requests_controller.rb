class RequestsController < ApplicationController
before_action :get_requests, except: [:accept_request, :send_request, :remove_friend]

   def index
      render("/requests/index.html.erb")
   end

   def accept_request
      friend = User.find_by(:id => params[:friend_id])
      if current_user.accept_request(friend)
         request = Request.find_by(:id => params[:request_id])
         request.destroy
         flash[:notice] = "You are now friends with #{friend.username}!"
      else
         flash[:alert] = "There was an error accepting this request"
      end

      if current_user.requests.count > 0
         redirect_to(:back)
      else
         redirect_to root_path
      end
   end

   def send_request
      friend = User.find_by(:id => params[:id])
      if current_user.friend_request(friend)
         request = Request.new
         request.uid = friend.id
         request.sender_id = current_user.id
         request.save

         flash[:notice] = "Friend request has been sent!"
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

private
   def get_requests
      @requests = current_user.requests
   end
end
