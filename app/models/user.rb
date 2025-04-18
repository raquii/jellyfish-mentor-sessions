class User < ApplicationRecord
  has_many :posts, inverse_of: :author, dependent: :destroy
  has_many :comments, inverse_of: :author, dependent: :destroy
end
