class RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    room = Room.create
    current_entry = Entry.create(user_id: current_user.id, room_id: room.id)
    another_entry = Entry.create(user_id: params[:entry][:user_id], room_id: room.id)
    redirect_to room_path(room)
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id,room_id: @room.id).present?
      @message = Message.new
      @entries = @room.entries.find_by('user_id != ?', current_user.id)
    else
      redirect_to root_path
    end
  end

  def destroy
  end
end
