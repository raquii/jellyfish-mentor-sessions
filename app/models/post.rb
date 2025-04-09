class Post < ApplicationRecord
  MAX_TITLE_LENGTH = 255
  MAX_BODY_LENGTH = 5000

  has_many :comments, as: :commentable
  belongs_to :author, class_name: "User"
end
