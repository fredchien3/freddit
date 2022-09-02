# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  url        :string
#  content    :text
#  sub_id     :bigint           not null
#  author_id  :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Post < ApplicationRecord
  validates_presence_of :title, :sub_id, :author_id

  belongs_to :author,
    class_name: :User

  belongs_to :sub

  has_many :comments,
    dependent: :destroy

    
  def comments_by_parent_id
    hash = Hash.new { |h, k| h[k] = [] }

    comments = Comment.where(post_id: self.id).joins(:author)
    comments.each do |comment|
      hash[comment.parent_comment_id] << comment
    end
    hash
  end
end
