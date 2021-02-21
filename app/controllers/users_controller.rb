class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_user

  def show
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

  def follow
    @users = @user.followings.order('relationships.created_at DESC')
  end

  def follower
    @users = @user.followers.order('relationships.created_at DESC')
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
