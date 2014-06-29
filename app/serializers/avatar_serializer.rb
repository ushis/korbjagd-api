class AvatarSerializer < ActiveModel::Serializer
  attributes :id, :urls, :created_at, :updated_at

  def urls
    object.image.versions.map { |k, v| [k, v.url] }.to_h
  end
end
