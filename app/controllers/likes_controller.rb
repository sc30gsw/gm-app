class LikesController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  before_action :set_man, only: [:create, :destroy]

  def index
    @user = User.find(params[:id])
    @mans = @user.liked_mans.order('likes.created_at DESC').page(params[:page]).per(5)

    @current_entry = Entry.where(user_id: current_user.id)
    @another_entry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @current_entry.each do |cu|
        @another_entry.each do |au|
          if cu.room_id == au.room_id
            @is_room = true
            @room_id = cu.room_id
          end
        end
      end

      unless @is_room
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def create
    @like = Like.new(user_id: current_user.id, man_id: params[:man_id])
    @like.save
    @man.create_notification_like(current_user)
    @likes = Like.where(man_id: @man.id).count
    redirect_to man_path(@man.id)
  end

  def destroy
    @like = Like.find_by(user_id: current_user.id, man_id: params[:man_id])
    @like.destroy
    @likes = Like.where(man_id: @man.id).count
  end

  private

  def set_man
    @man = Man.find(params[:man_id])
  end
end
