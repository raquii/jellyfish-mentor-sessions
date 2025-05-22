class PostsController < ApplicationController
  skip_before_action :require_authentication, only: :index
  before_action :find_post, only: [ :show, :update, :destroy, :edit ]

  rescue_from ActiveRecord::RecordInvalid, with: :render_response_invalid

  # GET /posts
  def index
    @posts = case
    when current_user&.admin?
      Post.all.recent
    when current_user
      Post.where(visibility: [ :visible, :limited ])
          .or(Post.where(visibility: :hidden, author: current_user)).recent
    else
      Post.visible.recent
    end
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

    flash[:success] = "Post successfully created!"
    redirect_to post_path(@post)
  rescue ActiveRecord::RecordInvalid => e
    @post = e.record
    flash[:error] = e.message
    render :new, status: :unprocessable_entity
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
    redirect_to posts_path
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :visibility)
  end

  def render_response_invalid(e)
    render json: { error: e.full_message }, status: :unprocessable_entity
  end
end
