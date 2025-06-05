class Api::PostsController < Api::BaseController
  before_action :find_post, only: [ :show, :update, :destroy ]
  before_action :authorize_post!, only: [ :update, :destroy ]
  # GET /api/posts
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

    render json: PostSerializer.new(@posts)
  end

  # GET /api/posts/:id
  def show
    if @post.visible_to(user: current_user)
      render json: @post, serializer: PostSerializer
    else
      render json: { error: "Post not found" }, status: :not_found
    end
  end

  # POST /api/posts
  def create
    @post = current_user.posts.create!(post_params)
    render json: PostSerializer.new(@post)
  end

  # PUT /api/posts/:id
  def update
    @post.update!(post_params)
    render json: PostSerializer.new(@post)
  end

  # DELETE /api/posts/:id
  def destroy
    @post.destroy
    render json: {}, status: :ok
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :visibility)
  end

  def authorize_post!
    unless current_user&.admin? || @post.author_id == current_user&.id
      render json: { error: "Resource not found" }, status: :not_found
    end
  end
end
