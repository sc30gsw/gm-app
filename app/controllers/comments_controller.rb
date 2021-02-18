class CommentsController < ApplicationController

  def index
    @mans = current_user.commented_mans.joins(:comments).order('comments.created_at DESC')
    @user = User.find(params[:id])
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
