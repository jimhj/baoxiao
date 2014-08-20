class CommentsController < ApplicationController
  before_action :login_required, only: [:create, :destroy]

  def create
    @joke = Joke.find params[:joke_id]
    @comment = @joke.comments.build comment_params
    @comment.save
  end

  def destroy
    @comment = Comment.find params[:id]
    @comment.destroy
  end

  def like
    @comment = Comment.find(params[:id])
    if login?
      return if current_user.liked?(@comment)
      current_user.like @comment
    else
      @comment.like_by_anonymous
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end
end