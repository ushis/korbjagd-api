class Avatar < ActiveRecord::Base
  belongs_to :user, inverse_of: :avatar, touch: true

  validates :user_id, presence: true
  validates :image,   presence: true

  mount_uploader :image, ImageUploader
end
