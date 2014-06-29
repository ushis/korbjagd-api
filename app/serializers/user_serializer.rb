class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :avatar_url

  def avatar_url
    object.avatar.image.thumb.url
  end
end
