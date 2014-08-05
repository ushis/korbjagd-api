class Basket < ActiveRecord::Base
  include PluckH

  belongs_to :user,   inverse_of: :baskets, counter_cache: true
  belongs_to :sector, inverse_of: :baskets, counter_cache: true, touch: true

  has_one :photo, inverse_of: :basket, dependent: :destroy

  has_many :comments, -> { order(:created_at) }, inverse_of: :basket, dependent: :destroy
  has_many :commenters, -> { uniq }, through: :comments, source: :user

  has_and_belongs_to_many :categories, inverse_of: :baskets, readonly: true

  validates :user_id,   presence: true
  validates :sector_id, presence: true
  validates :name,      presence: true, length: {maximum: 255}
  validates :latitude,  presence: true, uniqueness: {scope: :longitude}
  validates :latitude,  numericality: {greater_than: -90, less_than: 90}
  validates :longitude, presence: true
  validates :longitude, numericality: {greater_than: -180, less_than: 180}

  before_validation :set_sector

  # Returns the baskets photo or raises ActiveRecord::RecordNotFound
  def photo!
    photo || raise(ActiveRecord::RecordNotFound.new('Basket has no photo.'))
  end

  # Returns the baskets point
  def point
    Point.new(latitude, longitude)
  end

  # Returns a cache key that can be used to identify this basket
  def cache_key
    [super, user.try(:cache_key)].compact.join('/')
  end

  # Returns the last time this basket or the associated user was touched
  def last_modified
    [updated_at, user.try(:updated_at)].compact.max
  end

  private

  # Sets the sector
  def set_sector
    self.sector = Sector.find_or_create_by_point(point)
  rescue ActiveRecord::RecordInvalid
    self.sector = nil
  end
end
