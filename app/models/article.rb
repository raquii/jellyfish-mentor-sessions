class Article < ApplicationRecord
  has_many :comments, as: :commentable

  def print_article
    "'#{title}' by #{author}: #{body}"
  end
end
