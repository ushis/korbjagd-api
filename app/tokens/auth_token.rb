class AuthToken < ApplicationToken
  ttl 1.day
  scope :auth
end
