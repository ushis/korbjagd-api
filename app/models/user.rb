class User < ActiveRecord::Base
  has_one :avatar, inverse_of: :user, dependent: :destroy

  has_many :baskets,  inverse_of: :user
  has_many :comments, inverse_of: :user, dependent: :destroy

  has_secure_password

  validates :username, presence: true, uniqueness: true, length: {maximum: 255}, format: /\A[a-z0-9]+\z/
  validates :email,    presence: true, uniqueness: true, length: {maximum: 255}, format: /.+@.+/
  validates :password, presence: true, on: :create
  validates :password, confirmation: true

  validates :password_confirmation, presence: true, unless: -> (u) { u.password.blank? }

  before_validation :normalize_username
  before_validation :normalize_email

  # Filters admins
  def self.admins
    where(admin: true)
  end

  # Filters users with notifications enabled
  def self.reachable
    where(notifications_enabled: true)
  end

  # Exlcudes the specified users from the relation
  def self.exclude(*users)
    where.not(id: users)
  end

  # Returns a user found by auth token or nil
  def self.find_by_auth_token(token)
    find_by_id(AuthToken.from_s(token.to_s).id)
  rescue JWT::DecodeError
    nil
  end

  # Returns a user found by password reset token or nil
  def self.find_by_password_reset_token(token)
    find_by_id(PasswordResetToken.from_s(token.to_s).id)
  rescue JWT::DecodeError
    nil
  end

  # Returns a user found by profile delete token or nil
  def self.find_by_delete_token(token)
    find_by_id(ProfileDeleteToken.from_s(token.to_s).id)
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

  # Returns a new password reset token for the user
  def password_reset_token
    PasswordResetToken.for(self).to_s
  end

  # Returns a new profile delete token for the user
  def delete_token
    ProfileDeleteToken.for(self).to_s
  end

  # Returns true if the has notifications enabled else false
  def reachable?
    notifications_enabled?
  end

  # Returns the avatar or raises ActiveRecord::RecordNotFound
  def avatar!
    avatar || raise(ActiveRecord::RecordNotFound.new('User has no avatar.'))
  end

  # Returns the email address with the username
  #
  #   user.email_with_name
  #   #=> "harry <dirty@harry.com>"
  #
  # Suitable for email headers
  def email_with_name
    "#{username} <#{email}>"
  end

  private

  # Downcases and strips the username
  def normalize_username
    self.username = username.to_s.strip.downcase
  end

  # Strips the email
  def normalize_email
    self.email = email.to_s.strip
  end
end
