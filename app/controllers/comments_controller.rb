class CommentsController < ApplicationController

  def create
    @comment = Comment.new(comment_params)
    if @comment.valid?
      @comment.save
      redirect_to man_path(@comment.man)
    else
      @man = @comment.man
      @comments = @man.comments
      render 'man/show'
    end
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id, man_id: params[:man_id])
  end
end
