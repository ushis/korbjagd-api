class Photo < ActiveRecord::Base
  belongs_to :user,   inverse_of: :photos
  belongs_to :basket, inverse_of: :photo, touch: true

  validates :user,   presence: true
  validates :basket, presence: true
  validates :image,  presence: true

  mount_uploader :image, ImageUploader

  # Returns a cache key that can be used to identify this photo
  def cache_key
    [super, user.try(:cache_key)].compact.join('/')
  end

  # Returns the last time this photo or the associated user was touched
  def last_modified
    [updated_at, user.try(:updated_at)].max
  end
end
