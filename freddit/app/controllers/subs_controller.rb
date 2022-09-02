class SubsController < ApplicationController
  before_action :require_logged_in, only: [:new, :create, :destroy]

  def index
    @subs = Sub.all.includes(:posts)
    render :index
  end

  def new
    @sub = Sub.new
    render :new
  end

  def create
    @sub = Sub.new(sub_params)
    @sub.moderator = current_user
    if @sub.save!
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def show
    subs = Sub.where(id: params[:id]).includes(:posts)
    @sub = subs.first
    render :show
  end

  def destroy
    @sub = Sub.find(params[:id])
    if current_user == @sub.moderator
      @sub.destroy
    else
      flash[:errors] = ["You must be the moderator of this sub!"]
      redirect_to subs_url
    end
  end

  def edit
    @sub = Sub.find(params[:id])
    render :edit
  end

  def update
    @sub = Sub.find(params[:id])
    @sub.description = sub_params[:description]
    @sub.save
    flash[:messages] = ["Successfully saved subfreddit info"]
    redirect_to sub_url @sub
  end

  private
  def sub_params
    params.require(:sub).permit(:title, :description)
  end
end
