class MansController < ApplicationController
  def index
  end

  def new
    @man = Man.new
  end

  def create
    @man = Man.new(man_params)
    if @man.valid?
      @man.save
      redirect_to :root_path
    else
      render :new
    end
  end

  private

  def man_params
    params.require(:man).permit(:name, :content, :category_id, :adress, :latitude, :longtude, :image).merge(user_id: current_user.id)
  end
end
