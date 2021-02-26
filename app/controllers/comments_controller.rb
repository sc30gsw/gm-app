class CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find(params[:id])
    @mans = @user.commented_mans.order('comments.created_at DESC').page(params[:page])

    @current_entry = Entry.where(user_id: current_user.id)
    @another_entry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @current_entry.each do |cu|
        @another_entry.each do |au|
          if cu.room_id == au.room_id
            @is_room = true
            @room_id = cu.room_id
          end
        end
      end

      unless @is_room
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def create
    @comment = Comment.new(comment_params)
    @man = @comment.man
    if @comment.valid?
      @comment.save
      @man.create_notification_comment(current_user, @comment.id)
      redirect_to man_path(@comment.man)
    else
      @man = @comment.man
      @comments = @man.comments
      render 'mans/show'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      redirect_to man_path(@comment.man_id)
    else
      render 'mans/show'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id, man_id: params[:man_id])
  end
end
