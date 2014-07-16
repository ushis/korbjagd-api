class AuthToken < ApplicationToken
  ttl 1.week
  scope :auth
end
