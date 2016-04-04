class PostsController < ApplicationController

  before_action :only_sign_in, only: [:new, :create]

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    if current_user
      @post = current_user.posts.build(post_params)
      if @post.save
        redirect_to root_path
      else
      end
    end
  end

  def edit

  end

  def destroy
    @post = Post.find(params[:id])
    if user_signed_in? && current_user.id == @post.user.id
      if @post.destroy
        redirect_to root_path
      end
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :content, :user_id)
  end

end