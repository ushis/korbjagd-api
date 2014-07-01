class Basket < ActiveRecord::Base
  belongs_to :user, inverse_of: :baskets, counter_cache: true

  has_one :photo, inverse_of: :basket, dependent: :destroy

  has_many :comments, inverse_of: :basket, dependent: :destroy

  has_and_belongs_to_many :categories, inverse_of: :baskets

  validates :name,      presence: true
  validates :latitude,  presence: true
  validates :longitude, presence: true
  validates :user_id,   presence: true

  # Filters for baskets inside the given bounds
  def self.in_bounds(bounds)
    where(<<-SQL, s: bounds.s, w: bounds.w, n: bounds.n, e: bounds.e)
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

  # Returns the photo of the basket or initializes a new one
  def photo
    super || build_photo
  end
end
