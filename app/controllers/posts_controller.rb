class PostsController < ApplicationController
  before_action :find_post, only: [ :show, :update, :destroy ]

  # GET /posts
  def index
    @posts = Post.all.order(created_at: :desc)
  end

  # GET /posts/:id
  def show
    render json: @post
  end

  # POST /posts
  def create
    @post = current_user.posts.create(post_params)
    render json: @post, status: :created
  end

  # PUT, PATCH /posts/:id
  def update
    @post.update(post_params)
    render json: @post
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
