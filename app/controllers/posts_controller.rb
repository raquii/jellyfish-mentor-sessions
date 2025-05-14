class PostsController < ApplicationController
  before_action :find_post, only: [ :show, :update, :destroy, :edit ]

  # GET /posts
  def index
    @posts = Post.all.order(created_at: :desc)
  end

  # GET /posts/:id
  def show
  end

  def new
    @post = Post.new
  end

  # POST /posts
  def create
    @post = current_user.posts.create!(post_params)
  end

  def edit
  end

  # PUT, PATCH /posts/:id
  def update
    @post.update!(post_params)
    redirect_to post_path(@post)
  end

  # DELETE /posts/:id
  def destroy
    @post.destroy
    render json: { message: 'Post deleted successfully' }, status: :ok
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
