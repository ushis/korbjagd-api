class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :url, :created_at, :updated_at

  def url
    object.image.url
  end
end
