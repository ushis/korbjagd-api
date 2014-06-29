class Avatar < ActiveRecord::Base
  belongs_to :user, inverse_of: :avatar

  validates :user_id, presence: true
  validates :filename,  presence: true
  validates :image,     presence: true

  mount_uploader :image, AvatarUploader
end
