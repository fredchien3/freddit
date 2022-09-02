class Comment < ApplicationRecord
  validates_presence_of :body, :author_id, :post_id

  belongs_to :post

  belongs_to :author,
    class_name: :User

  belongs_to :parent_comment,
    class_name: :Comment,
    optional: true

  has_many :child_comments,
    foreign_key: :parent_comment_id,
    class_name: :Comment

end
