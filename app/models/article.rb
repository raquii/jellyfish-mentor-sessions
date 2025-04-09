class Article < ApplicationRecord
  has_many :comments, as: :commentable
  belongs_to :author, class_name: "User"
end
