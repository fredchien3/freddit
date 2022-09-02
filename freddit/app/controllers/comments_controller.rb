class CommentsController < ApplicationController
  before_action :require_logged_in, only: [:new, :create, :destroy]

  def new
    @comment = Comment.new
    @post_id = params[:post_id]
    render :new
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.author = current_user
    if @comment.save!
      redirect_to post_url @comment.post
    else
      flash.now[:errors] = @comment.errors.full_messages
      render :new
    end
  end

  def show
    @comment = Comment.find(params[:id])
    @comments = @comment.comments
    render :show
  end

  def destroy
    if current_user == @comment.moderator
      @comment = Comment.find(params[:id])
      @comment.destroy if @comment
    else
      flash[:errors] = ["You must be the moderator of this comment!"]
      redirect_to comments_url
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    render :edit
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.description = comment_params[:description]
    @comment.save
    flash[:messages] = ["Successfully saved commentfreddit info"]
    redirect_to post_url @comment.post
  end

  private
  def comment_params
    params.require(:comment).permit(:body, :post_id)
  end
end
