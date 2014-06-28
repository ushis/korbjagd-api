class Comment < ActiveRecord::Base
  belongs_to :user,   inverse_of: :comments
  belongs_to :basket, inverse_of: :comments, counter_cache: true

  validates :user_id,   presence: true
  validates :basket_id, presence: true
  validates :comment,   presence: true
end
