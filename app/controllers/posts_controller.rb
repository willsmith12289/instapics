class PostsController < ApplicationController
  before_action :authenticate_user!

  before_action :owned_post, only: [:edit, :update, :destroy]
  
  before_action :set_post, only: [:show, :edit, :update, :destroy, :liked]

  def index
    @posts = Post.all.order('created_at DESC').page params[:page]

  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Your post has been created!"
      redirect_to posts_path
    else
      flash.now[:alert] = "Your new post couldn't be created! Please check the form."
      render :new
    end
  end

  def show

  end

  def liked
    if @post.liked_by current_user
      respond_to do |format|
        format.html { redirect_to :back }
        format.js
      end
    end
  end

  def edit
    
  end

  def update
    if @post.update(post_params)
      flash[:success] = "Post updated."
      redirect_to(post_path(@post))
    else
      flash.now[:alert] = "Update failed.  Please check the form."
      render :edit
    end
  end

  def destroy
    @post.destroy
    flash[:success] = "Post deleted."
    redirect_to posts_path
  end
  private

  def post_params
    params.require(:post).permit(:image, :caption)
  end

  def set_post
    @post = Post.find(params[:id])
  end


  def owned_post
    @post = Post.find(params[:id])
    unless current_user.id == @post.user_id
      flash[:alert] = "That post doesn't belong to you!"
      redirect_to root_path
    end
  end

end
