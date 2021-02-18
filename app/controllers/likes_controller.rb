class LikesController < ApplicationController
  before_action :set_man, only: [:create, :destroy]

  def index
    @user = User.find(params[:id])
    @mans = @user.liked_mans.joins(:likes).order('likes.created_at DESC')
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
