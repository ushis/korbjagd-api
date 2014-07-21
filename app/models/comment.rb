class Comment < ActiveRecord::Base
  belongs_to :user,   inverse_of: :comments
  belongs_to :basket, inverse_of: :comments, counter_cache: true

  validates :user_id,   presence: true
  validates :basket_id, presence: true
  validates :comment,   presence: true

  # Returns a cache key that can be used to identify this comment
  def cache_key
    [super, user.cache_key].join('/')
  end

  # Returns the last time this comment or the associated user was touched
  def last_modified
    [updated_at, user.updated_at].max
  end
end
