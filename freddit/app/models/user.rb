# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  attr_reader :password

  before_validation :ensure_session_token
  validates :username, :session_token, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: true

  has_many :moderated_subreddits,
    foreign_key: :moderator_id,
    class_name: :Sub
  
  has_many :comments,
    foreign_key: :author_id

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    user && user.is_password?(password) ? user : nil
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password? password
  end

  def generate_unique_session_token
    token = SecureRandom.urlsafe_base64
    while User.find_by(session_token: token)
      token = SecureRandom.urlsafe_base64
    end
    token
  end

  def ensure_session_token
    if self.session_token.nil?
      self.session_token = self.generate_unique_session_token
    end
  end

  def reset_session_token!
    self.session_token = self.generate_unique_session_token
    self.save
    self.session_token
  end
end
