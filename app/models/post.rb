class Post < ApplicationRecord
  MIN_TITLE_LENGTH = 1
  MAX_TITLE_LENGTH = 255
  MIN_BODY_LENGTH = 1
  MAX_BODY_LENGTH = 5000

  has_many :comments, as: :commentable
  belongs_to :author, class_name: "User"
  validates :title, presence: true, length: { in: MIN_TITLE_LENGTH..MAX_TITLE_LENGTH }
  validates :body, presence: true, length: { in: MIN_BODY_LENGTH..MAX_BODY_LENGTH }

  scope :recent, -> { order(created_at: :desc) }

  enum :visibility, { visible: 0, hidden: 1, limited: 2 }

  def visible_to(user: nil)
    author_id == user&.id || user&.admin? || visible?
  end

  def print_post
    "Title: #{title} By: #{author.name} Body: #{body}"
  end

  def to_s
    title
  end
end
