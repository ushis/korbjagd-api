class Photo < ActiveRecord::Base
  belongs_to :basket, inverse_of: :photo

  validates :basket_id, presence: true
  validates :image,     presence: true

  mount_uploader :image, ImageUploader

  def image=(image)
    super(DataUrlFile.new(image))
  rescue ArgumentError
    super(image)
  end
end
