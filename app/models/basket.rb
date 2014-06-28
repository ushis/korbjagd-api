class Basket < ActiveRecord::Base
  belongs_to :user, inverse_of: :baskets

  has_many :comments, inverse_of: :basket, dependent: :destroy

  has_and_belongs_to_many :categories, inverse_of: :baskets

  validates :name,      presence: true
  validates :latitude,  presence: true
  validates :longitude, presence: true
  validates :user_id,   presence: true

  # Filters for baskets inside the given bounds
  def self.in_bounds(b)
    where(<<-SQL, s: b.sw.lat, w: b.sw.lng, n: b.ne.lat, e: b.ne.lng)
      baskets.latitude > :s AND
      baskets.longitude > :w AND
      baskets.latitude < :n AND
      baskets.longitude < :e
    SQL
  end

  # Assigns categories to the basket
  def category_ids=(ids)
    self.categories = Category.where(id: ids)
  end
end
