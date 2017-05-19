class MessagesController < ApplicationController
  def index
    @messages = Message.all

    render("messages/index.html.erb")
  end

  def show
    @message = Message.find(params[:id])

    render("messages/show.html.erb")
  end

  def new
    @message = Message.new

    render("messages/new.html.erb")
  end

  def create
    @message = Message.new

    @message.recipient_id = params[:recipient_id]
    @message.sender_id = params[:sender_id]
    @message.message = params[:message]
    @message.read_status = params[:read_status]

    save_status = @message.save

    if save_status == true
      redirect_to("/messages/#{@message.id}", :notice => "Message created successfully.")
    else
      render("messages/new.html.erb")
    end
  end

  def edit
    @message = Message.find(params[:id])

    render("messages/edit.html.erb")
  end

  def update
    @message = Message.find(params[:id])

    @message.recipient_id = params[:recipient_id]
    @message.sender_id = params[:sender_id]
    @message.message = params[:message]
    @message.read_status = params[:read_status]

    save_status = @message.save

    if save_status == true
      redirect_to("/messages/#{@message.id}", :notice => "Message updated successfully.")
    else
      render("messages/edit.html.erb")
    end
  end

  def destroy
    @message = Message.find(params[:id])

    @message.destroy

    if URI(request.referer).path == "/messages/#{@message.id}"
      redirect_to("/", :notice => "Message deleted.")
    else
      redirect_to(:back, :notice => "Message deleted.")
    end
  end
end
