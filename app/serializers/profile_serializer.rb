class ProfileSerializer < UserSerializer
  attributes :email, :admin, :baskets_count, :created_at, :updated_at
end
