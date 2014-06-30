class ProfileSerializer < UserSerializer
  attributes :email, :admin, :created_at, :updated_at
end
