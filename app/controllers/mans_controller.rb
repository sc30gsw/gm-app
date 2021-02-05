class MansController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_man, only: [:show]

  def index
    @mans = Man.includes(:user)
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

  def show
  end

  def category
    @man = Man.find_by(category_id: params[:id])
    @mans = Man.where(category_id: params[:id]).order('created_at DESC')
    @category = Category.find(params[:id])
  end

  private

  def man_params
    params.require(:man).permit(:name, :content, :category_id, :address, :latitude, :longitude, :image).merge(user_id: current_user.id)
  end

  def set_man
    @man = Man.find(params[:id])
  end
end
