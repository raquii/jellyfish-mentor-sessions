class User < ApplicationRecord
  has_many :posts, inverse_of: :author, dependent: :destroy
  has_many :comments, inverse_of: :author, dependent: :destroy

  has_secure_password

  validates_uniqueness_of :email
  validates_presence_of :name, :email

  # Role-Based Access Control
  enum :role, { user: 0, admin: 1 }

  def to_s
    name
  end
end
