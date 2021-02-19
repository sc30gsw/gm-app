class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def follow
    @follow_user = User.find(params[:id])
    @users = @follow_user.followings.order('relationships.created_at DESC')
  end
end
