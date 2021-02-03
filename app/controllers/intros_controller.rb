class IntrosController < ApplicationController
  before_action :set_intro, only: [:edit, :update]

  def new
    @intro = Intro.new
    redirect_to user_path(current_user.id) if Intro.find_by(user_id: current_user.id)
  end

  def create
    @intro = Intro.new(intro_params)
    if @intro.save
      redirect_to user_path(@intro.user.id)
    else
      render :new
    end
  end

  def edit
    unless current_user.id == @intro.user_id
      redirect_to user_path(current_user.id)
    end
  end

  def update
    if @intro.update(intro_params)
      redirect_to user_path(@intro.user.id)
    else
      render :edit
    end
  end

  private

  def intro_params
    params.require(:intro).permit(:profile, :website, :image).merge(user_id: current_user.id)
  end

  def set_intro
    @intro = Intro.find(params[:id])
  end

end
