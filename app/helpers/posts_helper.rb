module PostsHelper
  def can_manage_post?(post)
    current_user&.admin? || post.author_id == current_user&.id
  end
end
