class MansController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @man = Man.includes(:user)
  end

  def new
    @man = Man.new
  end

  def create
    @man = Man.new(man_params)
    if @man.valid?
      @man.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def man_params
    params.require(:man).permit(:name, :content, :category_id, :address, :latitude, :longitude, :image).merge(user_id: current_user.id)
  end
end
