class PostsController < ApplicationController
  before_action :require_logged_in, only: [:new, :create, :destroy]

  def new
    @post = Post.new
    @sub = Sub.find(params[:sub_id])
    render :new
  end

  def create
    @post = Post.new(post_params)
    @post.sub = Sub.find(params[:sub_id])
    @post.author = current_user
    if @post.save!
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    # @all_comments = Comment.where(post_id: params[:id]).joins(:author)
    @comments_hash = @post.comments_by_parent_id
    render :show
  end

  def destroy
    @post = Post.find(params[:id])
    if current_user == @post.author
      @post.destroy if @post
    else
      flash[:errors] = ["You must be the author of this post!"]
      redirect_to posts_url
    end
  end

  def edit
    @post = Post.find(params[:id])
    render :edit
  end

  def update
    @post = Post.find(params[:id])
    @post.description = post_params[:description]
    @post.save
    flash[:messages] = ["Successfully saved postfreddit info"]
    redirect_to post_url @post
  end

  private
  def post_params
    params.require(:post).permit(:title, :description)
  end
end
