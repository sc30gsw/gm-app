class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: [:show, :destroy]

  def index
    @current_entries = current_user.entries
    my_room_ids = []
    @current_entries.each do |entry|
      my_room_ids << entry.room.id
    end
    @another_entries = Entry.where(room_id: my_room_ids).where.not(user_id: current_user.id)
  end

  def create
    room = Room.create
    current_entry = Entry.create(user_id: current_user.id, room_id: room.id)
    another_entry = Entry.create(user_id: params[:entry][:user_id], room_id: room.id)
    redirect_to room_path(room)
  end

  def show
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @message = Message.new
      @entries = @room.entries.find_by('user_id != ?', current_user.id)
    else
      redirect_to root_path
    end
  end

  def destroy
    @entries = @room.entries.find_by('user_id != ?', current_user.id)
    if @room.destroy
      redirect_to user_path(@entries.user_id)
    else
      render action: :show
    end
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end
end
