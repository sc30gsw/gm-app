class UsersController < ApplicationController
  before_action :set_user

  def show
  end

  def follow
    @users = @user.followings.order('relationships.created_at DESC')
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
  
end
