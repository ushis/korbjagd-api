class AuthToken < ApplicationToken
  ttl 1.month
  scope :auth
end
