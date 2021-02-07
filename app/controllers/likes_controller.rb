class LikesController < ApplicationController

  def create
    @like = Like.create(user_id: current_user.id, man_id: params[:man_id])
  end
  
  def destroy
    @like = Like.find_by(user_id: current_user.id, man_id: params[:man_id])
    @like.destroy
  end
  
end
