class MansController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_man, only: [:show, :edit, :update, :destroy, :like]

  def index
    @mans = Man.includes(:user).sort { |a, b| b.liked_users.count <=> a.liked_users.count }
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
    @comment = Comment.new
    @comments = @man.comments.includes(:user).order('created_at DESC')
    @likes = Like.where(man_id: @man.id).count
  end

  def edit
    redirect_to man_path(@man.id) unless current_user.id == @man.user_id
  end

  def update
    if @man.update(man_params)
      redirect_to man_path(@man.id)
    else
      render :edit
    end
  end

  def destroy
    if @man.destroy
      redirect_to root_path
    else
      render :show
    end
  end

  def category
    @man = Man.find_by(category_id: params[:id])
    @mans = Man.where(category_id: params[:id]).order('created_at DESC')
    @category = Category.find(params[:id])
  end

  def timeline
    @followings = current_user.followings
    @mans = Man.where(user_id: @followings).or(Man.where(user_id: current_user.id)).order('created_at DESC')
  end

  def tag
    @tag = Tag.find_by(name: params[:name])
    @mans = @tag.mans
  end

  def search
    @mans = Man.search(params[:keyword])
  end

  def Like
  end

  private

  def man_params
    params.require(:man).permit(:name, :content, :tagbody, :category_id, :address, :latitude, :longitude, :image).merge(user_id: current_user.id)
  end

  def set_man
    @man = Man.find(params[:id])
  end
end
