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

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end
end