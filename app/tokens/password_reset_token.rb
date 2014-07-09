class PasswordResetToken < ApplicationToken
  ttl 30.minutes
  scope :password_reset
end
