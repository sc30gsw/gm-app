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
    @message = Message.new
    @another_entry = @room.entries.find_by('user_id != ?', current_user.id)
  end
end
