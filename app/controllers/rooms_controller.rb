class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: [:show, :destroy]

  def create
    @room = Room.create
    @current_entry = Entry.create(user_id: current_user.id, room_id: @room.id)
    @another_entry = Entry.create(user_id: params[:entry][:user_id], room_id: @room.id)
    redirect_to room_path(@room)
  end

  def show
    if Entry.where(user_id: current_user.id,room_id: @room.id).present?
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
