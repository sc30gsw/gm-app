class LikesController < ApplicationController
  before_action :set_man

  def create
    @like = Like.create(user_id: current_user.id, man_id: params[:man_id])
    if @like.save
      redirect_to man_path(@man.id)
    else
      render "mans/show"
  end
  
  def destroy
    @like = Like.find_by(user_id: current_user.id, man_id: params[:man_id])
    if @like.destroy
      redirect_to man_path(@man.id)
    else
      render "mans/show"
  end

  private 

  def set_man
    @man = Man.find(params[:man_id])
  end

end
