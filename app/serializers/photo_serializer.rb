class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :thumb, :small, :medium, :original, :created_at, :updated_at

  def thumb
    object.image.thumb.url
  end

  def small
    object.image.small.url
  end

  def medium
    object.image.medium.url
  end

  def original
    object.image.url
  end
end
