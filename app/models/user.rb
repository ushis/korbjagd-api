class User < ActiveRecord::Base
  has_many :baskets,  inverse_of: :user
  has_many :comments, inverse_of: :user, dependent: :destroy

  has_secure_password

  validates :username, presence: true, uniqueness: true, format: /[a-z0-9]+/
  validates :email,    presence: true, uniqueness: true, format: /.+@.+/
  validates :password, presence: true, on: :create
  validates :password, confirmation: true

  before_validation :normalize_username

  # Returns a user found by auth token or nil
  def self.find_by_auth_token(token)
    find_by_id(AuthToken.from_s(token.to_s).id)
  rescue JWT::DecodeError
    nil
  end

  # Finds a user by email/username
  def self.find_by_email_or_username(q)
    where('users.email = :q OR users.username = :q', q: q).first
  end

  # Returns a new auth token for the user
  def auth_token
    AuthToken.for(self).to_s
  end

  private

  # Downcases the username
  def normalize_username
    self.username = username.to_s.downcase
  end
end
