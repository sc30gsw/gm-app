class MessagesController < ApplicationController

  def create
    @message = Message.new(message_params)
    @message.user_id = current_user.id
    if @message.valid?
      @message.save
      redirect_to room_path(@message.room)
    else
      @room = @message.room
      @entries = @room.entries.find_by('user_id != ?', current_user.id)
      render "rooms/show"
    end
  end

  def destroy
    @message = Message.find(params[:id])
    if @message.destroy
      redirect_to room_path(@message.room)
    else
      @room = @message.room
      @messages = @room.messsages
      @entries = @room.entries.find_by('user_id != ?', current_user.id)
      render "rooms/show"
    end
  end
  
  private

  def message_params
    params.require(:message).permit(:text, :room_id).merge(user_id: current_user.id)
  end
end
