class PasswordResetToken < ApplicationToken

  # Default time to live
  TTL = 30.minutes

  # Returns a new token for a user
  def self.for(user, ttl=TTL)
    super(user, ttl)
  end
end
