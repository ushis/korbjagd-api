class Point < Struct.new(:latitude, :longitude)
  include ActiveModel::Validations

  validates :latitude,  presence: true
  validates :latitude,  numericality: {greater_than: -90.0, less_than: 90.0}
  validates :longitude, presence: true
  validates :longitude, numericality: {greater_than: -180.0, less_than: 180.0}

  alias :lat  :latitude
  alias :lat= :latitude=

  alias :lng  :longitude
  alias :lng= :longitude=

  # Returns a string representation of the point
  def to_s
    "(#{latitude},#{longitude})"
  end
end
