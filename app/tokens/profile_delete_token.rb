class ProfileDeleteToken < ApplicationToken
  ttl 5.minutes
  scope :profile_delete
end
