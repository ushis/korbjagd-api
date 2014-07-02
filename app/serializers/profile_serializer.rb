class ProfileSerializer < UserSerializer
  attributes :email, :notifications_enabled ,:admin, :baskets_count,
             :created_at, :updated_at
end
